#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import process from "node:process";
import { useEffect, useState } from "npm:react@18";
import { Newline, useApp, useInput, Box, render, Text } from "npm:ink";
import { match } from "npm:ts-pattern";
import { useCallback } from "react";

const enterAltScreenCommand = "\x1b[?1049h";
const leaveAltScreenCommand = "\x1b[?1049l";

const encoder = new TextEncoder();
const decoder = new TextDecoder();

function useStdoutDimensions() {
	const { columns, rows } = Deno.consoleSize();
	const [size, setSize] = useState({ columns, rows });

	useEffect(() => {
		function onResize() {
			const { columns, rows } = Deno.consoleSize();
			setSize({ columns, rows });
		}
		process.stdout.on("resize", onResize);
		return () => {
			process.stdout.off("resize", onResize);
		};
	}, []);

	return size;
}

type RawPipewireSource = {
	id: number;
	info: {
		props: {
			"media.class": string;
			"node.name": string;
			"node.nick": string;
		};
		params: {
			Props: Array<
				| {
						volume: number;
						mute: boolean;
				  }
				| {
						device: string;
				  }
			>;
		};
	};
};

type RawDefaultMetadata = {
	id: number;
	type: "PipeWire:Interface:Metadata";
	props: {
		"metadata.name": "default";
	};
	metadata: Array<{
		key: "default.audio.sink" | "default.audio.source";
		value: {
			name: string;
		};
	}>;
};

type DefaultMetadata = {
	defaultSink: string;
	defaultSource: string;
};

type PipewireSource = {
	id: number;
	name: string;
	volume: number;
	mute: boolean;
	unknown: boolean;
	active: boolean;
};

function transformMetadata(
	rawMetadata: RawDefaultMetadata,
): Partial<DefaultMetadata> {
	const defaultSinkData = rawMetadata.metadata.find(
		({ key }) => key === "default.audio.sink",
	);

	const defaultSourceData = rawMetadata.metadata.find(
		({ key }) => key === "default.audio.source",
	);

	return {
		defaultSink: defaultSinkData?.value?.name,
		defaultSource: defaultSourceData?.value?.name,
	};
}

function transformSource(
	nodeType: "sink" | "source",
	defaultMetadata?: DefaultMetadata,
) {
	return function (rawSource: RawPipewireSource): PipewireSource {
		const volumeData = rawSource.info.params.Props.find(
			(prop) => "volume" in prop,
		);

		return {
			id: rawSource.id,
			name: rawSource.info.props["node.nick"],
			volume: volumeData?.volume ?? 0,
			mute: volumeData?.mute ?? false,
			unknown: !volumeData,
			active: match(nodeType)
				.with("sink", () => {
					return (
						rawSource.info.props["node.name"] === defaultMetadata?.defaultSink
					);
				})
				.with(
					"source",
					() =>
						rawSource.info.props["node.name"] ===
						defaultMetadata?.defaultSource,
				)
				.otherwise(() => false),
		};
	};
}

async function reloadSinksAndSources() {
	const sourcesCommand = new Deno.Command("pw-dump");

	const { stdout } = await sourcesCommand.output();

	const allEntries: Array<RawPipewireSource | RawDefaultMetadata> = JSON.parse(
		decoder.decode(stdout),
	);

	const defaultMetadata = allEntries
		.filter((entry) => entry?.props?.["metadata.name"] === "default")
		.map(transformMetadata)
		.at(0);

	const sinks = allEntries
		.filter(
			(entry) =>
				entry?.info?.props?.["media.class"] === "Audio/Sink" &&
				entry?.type === "PipeWire:Interface:Node",
		)
		.map(transformSource("sink", defaultMetadata));

	const sources = allEntries
		.filter(
			(entry) =>
				entry?.info?.props?.["media.class"] === "Audio/Source" &&
				entry?.type === "PipeWire:Interface:Node",
		)
		.map(transformSource("source", defaultMetadata));

	return {
		sinks,
		sources,
	};
}

function Hello() {
	const app = useApp();

	const { rows, columns } = useStdoutDimensions();
	const [sinks, setSinks] = useState<Array<PipewireSource>>([]);
	const [sources, setSources] = useState<Array<PipewireSource>>([]);

	const [row, setRow] = useState(0);
	const [column, setColumn] = useState(0);

	const onChangeDefault = useCallback((id: number) => {
		new Deno.Command("wpctl", {
			args: ["set-default", String(id)],
			stdout: "null",
		}).outputSync();

		reloadSinksAndSources().then(({ sinks, sources }) => {
			setSinks(sinks);
			setSources(sources);
		});
	}, []);

	const onChangeMute = useCallback((id: number) => {
		new Deno.Command("wpctl", {
			args: ["set-mute", String(id), "toggle"],
			stdout: "null",
		}).outputSync();

		reloadSinksAndSources().then(({ sinks, sources }) => {
			setSinks(sinks);
			setSources(sources);
		});
	}, []);

	useEffect(() => {
		globalThis.addEventListener("unload", () => {
			Deno.stdout.write(encoder.encode(leaveAltScreenCommand));
		});

		reloadSinksAndSources().then(({ sinks, sources }) => {
			setSinks(sinks);
			setSources(sources);
		});
	}, []);

	useInput((input, key) => {
		if (input === "h" || input === "l") {
			setColumn((previousColumn) => (previousColumn === 0 ? 1 : 0));
			setRow(0);
		}

		if (input === "j") {
			const maxLength = match(column)
				.with(1, () => sources.length)
				.with(0, () => sinks.length)
				.otherwise(() => 0);

			setRow((previousRow) => (previousRow + 1) % maxLength);
		}

		if (input === "k") {
			const maxLength = match(column)
				.with(1, () => sources.length)
				.with(0, () => sinks.length)
				.otherwise(() => 0);

			setRow((previousRow) => (maxLength + previousRow - 1) % maxLength);
		}

		if (input === " ") {
			const nodeId = match(column)
				.with(1, () => sources)
				.with(0, () => sinks)
				.otherwise(() => [])
				?.at(row)?.id;

			if (nodeId !== undefined) {
				onChangeDefault(nodeId);
			}
		}

		if (input === "m") {
			const nodeId = match(column)
				.with(1, () => sources)
				.with(0, () => sinks)
				.otherwise(() => [])
				?.at(row)?.id;

			if (nodeId !== undefined) {
				onChangeMute(nodeId);
			}
		}

		if (input === "q" || key.escape) {
			app.exit();
		}
	});

	return (
		<Box flexDirection="row" width={columns} height={rows}>
			<Box
				flexGrow={1}
				flexShrink={0}
				borderStyle="single"
				flexDirection="column"
				justifyContent="flex-start"
			>
				<Text>Output</Text>
				<Newline />
				{sinks.map((entry, index) => (
					<Box key={entry.id} flexDirection="row" gap={1} paddingX={1}>
						<Text inverse={column === 0 && row === index}>{entry.name}</Text>
						{entry.active && <Text> </Text>}
						{entry.mute && <Text> </Text>}
						{entry.unknown && <Text>?</Text>}
					</Box>
				))}
			</Box>

			<Box
				flexGrow={1}
				flexShrink={0}
				borderStyle="single"
				flexDirection="column"
				justifyContent="flex-start"
			>
				<Text>Input</Text>
				<Newline />
				{sources.map((entry, index) => (
					<Box key={entry.id} flexDirection="row" gap={1} paddingX={1}>
						<Text inverse={column === 1 && row === index}>{entry.name}</Text>
						{entry.active && <Text> </Text>}
						{entry.mute && <Text> </Text>}
						{entry.unknown && <Text>?</Text>}
					</Box>
				))}
			</Box>
		</Box>
	);
}

Deno.stdout.write(encoder.encode(enterAltScreenCommand));
render(<Hello />, {
	debug: true,
});

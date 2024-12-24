#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import { spawn } from "node:child_process";
import process from "node:process";
import { Box, Text, render, useApp, useInput } from "npm:ink";
// @ts-types="npm:@types/react@18"
import { useCallback, useEffect, useState } from "npm:react@18";
import { match, P } from "npm:ts-pattern";

const enterAltScreenCommand = "\x1b[?1049h";
const leaveAltScreenCommand = "\x1b[?1049l";

const encoder = new TextEncoder();

function configDir(): string | null {
	switch (Deno.build.os) {
		case "linux": {
			const xdg = Deno.env.get("XDG_CONFIG_HOME");
			if (xdg) return xdg;

			const home = Deno.env.get("HOME");
			if (home) return `${home}/.config`;
			break;
		}

		case "darwin": {
			const home = Deno.env.get("HOME");
			if (home) return `${home}/Library/Preferences`;
			break;
		}

		case "windows":
			return Deno.env.get("FOLDERID_RoamingAppData") ?? null;
	}

	return null;
}

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

type Option = {
	description: string;
	shortcut: string;
} & (
	| {
			run: string;
			args?: string[];
	  }
	| {
			script: string;
			shell?: string;
	  }
	| {
			switch: string;
	  }
);

type Configuration = {
	shell: string;
	on_exit?: string;
	options: Record<string, Array<Option>>;
};

function Chorder() {
	const app = useApp();

	const { rows, columns } = useStdoutDimensions();

	const [configuration, setConfiguration] = useState<
		Configuration | undefined
	>();
	const [error, setError] = useState<Error | undefined>();
	const [currentMenu, setCurrentMenu] = useState<string>("main");

	const loadConfiguration = useCallback(() => {
		Deno.readTextFile(`${configDir()}/chorder/config.json`)
			.then((rawConfiguration) => {
				setConfiguration(JSON.parse(rawConfiguration));
			})
			.catch((error) => {
				setError(error);
			});
	}, [setError, setConfiguration]);

	const exitApp = useCallback(() => {
		if (configuration?.on_exit) {
			spawn(configuration.on_exit, [], {
				detached: true,
				stdio: ["ignore", "ignore", "ignore"],
			});
		}

		app.exit();
	}, [configuration]);

	useEffect(() => {
		globalThis.addEventListener("unload", () => {
			Deno.stdout.write(encoder.encode(leaveAltScreenCommand));
		});

		loadConfiguration();
	}, []);

	const runCommand = useCallback(
		(command: string, args?: string[]) => {
			const commandToRun = `${command} ${(args ?? []).join(" ")}`;

			spawn("hyprctl", ["dispatch", "exec", commandToRun], {
				detached: true,
				stdio: ["ignore", "ignore", "ignore"],
			});
			exitApp();
		},
		[exitApp],
	);

	const runShellCommand = useCallback(
		(command: string, shell?: string) => {
			const finalShell = shell ?? configuration?.shell;

			if (!finalShell) {
				return;
			}

			const commandToRun = `${finalShell} -c ${command}`;

			spawn("hyprctl", ["dispatch", "exec", commandToRun], {
				detached: true,
				stdio: ["ignore", "ignore", "ignore"],
			});
			exitApp();
		},
		[configuration, exitApp],
	);

	useInput((input, key) => {
		const isQuit = input === "q" || key.escape;

		try {
			match({ input, key, isQuit, currentMenu })
				.with({ input: P.string.regex(/[a-pr-zA-PR-Z]/) }, () => {
					if (!configuration) {
						return;
					}

					const finalKey = [key.ctrl && "c", key.shift && "s", input]
						.filter(Boolean)
						.join("-");

					const foundAction = configuration.options[currentMenu]?.find(
						({ shortcut }) => shortcut === finalKey,
					);

					try {
						match(foundAction)
							.with({ run: P.nonNullable }, ({ run, args }) => {
								runCommand(run, args);
							})
							.with({ script: P.nonNullable }, ({ script, shell }) => {
								runShellCommand(script, shell);
							})
							.with({ switch: P.nonNullable }, ({ switch: newMenu }) => {
								setCurrentMenu(newMenu);
							})
							.run();
					} catch {
						// ignore errors
					}
				})
				.with({ isQuit: true, currentMenu: P.not("main") }, () => {
					setCurrentMenu("main");
				})
				.with({ isQuit: true }, () => {
					exitApp();
				})
				.run();
		} catch {
			// ignore errors
		}
	});

	if (!configuration) {
		return <Box />;
	}

	if (error) {
		return (
			<Box>
				<Text>{error.message}</Text>
			</Box>
		);
	}

	return (
		<Box flexDirection="column" width={columns} height={rows}>
			{configuration.options[currentMenu]?.map(({ description, shortcut }) => (
				<Box key={shortcut} flexDirection="row" alignItems="center">
					<Box borderStyle="single" width={9} justifyContent="center">
						<Text>{shortcut}</Text>
					</Box>
					<Box borderStyle="single" flexGrow={1}>
						<Text> {description} </Text>
					</Box>
				</Box>
			))}
		</Box>
	);
}

Deno.stdout.write(encoder.encode(enterAltScreenCommand));
render(<Chorder />, {
	debug: true,
});

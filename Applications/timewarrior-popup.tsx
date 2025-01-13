#!/usr/bin/env -S deno run --allow-env --allow-read --allow-run

import process from "node:process";
// @ts-types="npm:@types/react@18"
import { useCallback, useEffect, useState } from "npm:react@18";
import { useApp, useInput, Newline, Box, render, Text } from "npm:ink";
import { match, P } from "npm:ts-pattern";
// @ts-types="npm:@types/luxon"
import { DateTime } from "npm:luxon";

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

type TimeEntry = {
	id: number;
	start?: string;
	end?: string;
	tags?: Array<string>;
};

type Task = {
	shortcut: string;
	description: string;
	tag: string;
	special_tasks?: Array<{
		shortcut: string;
		description: string;
		task: string;
	}>;
};

type State =
	| "main"
	| "confirm"
	| "select"
	| "selectTask"
	| "selectHour"
	| "selectManualTask";

type TaskData =
	| {
			kind: "new";
			tag: string;
	  }
	| {
			kind: "newWithHour";
			tag: string;
			task: string;
			hour: string;
	  }
	| {
			kind: "newEmptyWithHour";
	  }
	| {
			kind: "edit";
			id: number;
			tag: string;
	  }
	| {
			kind: "continueWithHour";
			id: number;
	  }
	| {
			kind: "stopWithHour";
	  }
	| {
			kind: "confirmDelete";
			id: number;
	  }
	| {
			kind: "replace";
			id: number;
			tag: string;
	  };

const maxTasks = 15;

const instructions = [
	"n - new",
	"N - new  ",
	"e - empty",
	"E - empty  ",
	"c - continue",
	"C - continue  ",
	"u - undo",
	"d - delete",
	"s - stop",
	"S - stop  ",
	"r - replace",
	"j - down",
	"k - up",
	"q - exit",
];

async function readConfigFile() {
	const file = await Deno.readTextFile(
		`${Deno.env.get("HOME")}/Projects/projects_timewarrior_data.json`,
	);

	return JSON.parse(file) as Array<Task>;
}

async function loadTimewarriorExport() {
	const exportTags = Array.from(
		{ length: maxTasks },
		(_, index) => `@${index + 1}`,
	);

	const exportCommand = new Deno.Command("timew", {
		args: ["export", ...exportTags],
		stdin: "null",
		stderr: "null",
	});

	const exportData = await exportCommand.output();

	return JSON.parse(decoder.decode(exportData.stdout))
		.toReversed()
		.map((entry) => ({
			...entry,
			start: match(
				DateTime.fromFormat(entry?.start ?? "", "yyyyMMdd'T'HHmmss'Z'", {
					zone: "UTC",
					locale: "pl",
				}).setZone("local"),
			)
				.with({ isValid: true }, (datetime) =>
					datetime.toLocaleString(DateTime.DATETIME_SHORT),
				)
				.otherwise(() => undefined),
			end: match(
				DateTime.fromFormat(entry?.end ?? "", "yyyyMMdd'T'HHmmss'Z'", {
					zone: "UTC",
					locale: "pl",
				}).setZone("local"),
			)
				.with({ isValid: true }, (datetime) =>
					datetime.toLocaleString(DateTime.DATETIME_SHORT),
				)
				.otherwise(() => undefined),
		})) as Array<TimeEntry>;
}

function TimewarriorPopup() {
	const { columns, rows } = useStdoutDimensions();
	const app = useApp();

	const [status, setStatus] = useState<string>("Siema!");
	const [error, setError] = useState<Error | undefined>();
	const [tasks, setTasks] = useState<Array<Task>>([]);
	const [timeEntries, setTimeEntries] = useState<Array<TimeEntry>>([]);
	const [state, setState] = useState<State>("main");
	const [stateData, setStateData] = useState<TaskData | undefined>();
	const [selectedTask, setSelectedTask] = useState<Task | undefined>();
	const [row, setRow] = useState(0);

	const [textInput, setTextInput] = useState("");

	const reloadTimewarriorExport = useCallback(() => {
		loadTimewarriorExport()
			.then(setTimeEntries)
			.catch((error) => {
				setError(error);
			});
	}, []);

	useEffect(() => {
		readConfigFile()
			.then(setTasks)
			.catch((error) => {
				setError(error);
			});

		reloadTimewarriorExport();

		globalThis.addEventListener("unload", () => {
			Deno.stdout.write(encoder.encode(leaveAltScreenCommand));
		});
	}, [reloadTimewarriorExport]);

	useInput((input, key) => {
		try {
			const isQuit = input === "q" || key.escape;

			match({ input, key, isQuit, state })
				.with({ input: "y", state: "confirm" }, () => {
					try {
						match(stateData)
							.with({ kind: "confirmDelete" }, ({ id }) => {
								const output = new Deno.Command("timew", {
									args: ["delete", `@${id}`],
								}).outputSync();
								setStatus(
									decoder
										.decode(output.code === 0 ? output.stdout : output.stderr)
										.split("\n")
										.filter((line) => !line.includes("Note:"))
										.at(0) ?? "",
								);
								setTextInput("");
								setState("main");
								setStateData(undefined);
								reloadTimewarriorExport();
							})
							.run();
					} catch {
						// ignore errors
					}
				})
				.with(
					{ input: "n", state: "confirm" },
					{ isQuit: true, state: "confirm" },
					() => {
						setTextInput("");
						setState("main");
						setStateData(undefined);
					},
				)

				.with(
					{ input: P.string.regex(/\d/), state: "selectManualTask" },
					({ input }) => {
						setTextInput((previousInput) => `${previousInput}${input}`);
					},
				)
				.with({ key: { backspace: true }, state: "selectManualTask" }, () => {
					setTextInput((previousInput) => previousInput.slice(0, -1));
				})
				.with({ isQuit: true, state: "selectManualTask" }, () => {
					setState("selectTask");
				})
				.with({ key: { return: true }, state: "selectManualTask" }, () => {
					if (textInput.length < 1) {
						return;
					}

					try {
						match(stateData)
							.with({ kind: "replace" }, ({ tag, id }) => {
								const output = new Deno.Command("timew", {
									args: ["retag", `@${id}`, `${tag}-${textInput}`],
								}).outputSync();
								setStatus(
									decoder
										.decode(output.code === 0 ? output.stdout : output.stderr)
										.split("\n")
										.filter((line) => !line.includes("Note:"))
										.at(0) ?? "",
								);
								setTextInput("");
								setState("main");
								setStateData(undefined);
								reloadTimewarriorExport();
							})
							.with({ kind: "newWithHour" }, (stateData) => {
								setState("selectHour");
								setStateData({
									...stateData,
									task: textInput,
								});
								setTextInput("");
							})
							.with({ kind: "new" }, ({ tag }) => {
								const output = new Deno.Command("timew", {
									args: ["start", `${tag}-${textInput}`],
								}).outputSync();
								setStatus(
									decoder
										.decode(output.code === 0 ? output.stdout : output.stderr)
										.split("\n")
										.filter((line) => !line.includes("Note:"))
										.at(0) ?? "",
								);
								setTextInput("");
								setState("main");
								setStateData(undefined);
								reloadTimewarriorExport();
							})
							.run();
					} catch {
						// ignore errors
					}
				})

				.with(
					{ input: P.string.regex(/\d/), state: "selectHour" },
					({ input }) => {
						setTextInput((previousInput) =>
							`${previousInput}${input}`.slice(0, 4),
						);
					},
				)
				.with({ key: { backspace: true }, state: "selectHour" }, () => {
					setTextInput((previousInput) => previousInput.slice(0, -1));
				})
				.with({ isQuit: true, state: "selectHour" }, () => {
					setState("selectTask");
				})
				.with({ key: { return: true }, state: "selectHour" }, () => {
					if (textInput.length < 4) {
						return;
					}

					try {
						match(stateData)
							.with({ kind: "newEmptyWithHour" }, () => {
								const output = new Deno.Command("timew", {
									args: [
										"start",
										`${textInput.slice(0, 2)}:${textInput.slice(2)}`,
									],
								}).outputSync();
								setStatus(
									decoder
										.decode(output.code === 0 ? output.stdout : output.stderr)
										.split("\n")
										.filter((line) => !line.includes("Note:"))
										.at(0) ?? "",
								);
								setTextInput("");
								setState("main");
								setStateData(undefined);
								reloadTimewarriorExport();
							})
							.with({ kind: "newWithHour" }, ({ tag, task }) => {
								const output = new Deno.Command("timew", {
									args: [
										"start",
										`${tag}-${task}`,
										`${textInput.slice(0, 2)}:${textInput.slice(2)}`,
									],
								}).outputSync();
								setStatus(
									decoder
										.decode(output.code === 0 ? output.stdout : output.stderr)
										.split("\n")
										.filter((line) => !line.includes("Note:"))
										.at(0) ?? "",
								);
								setTextInput("");
								setState("main");
								setStateData(undefined);
								reloadTimewarriorExport();
							})
							.with({ kind: "continueWithHour" }, ({ id }) => {
								const output = new Deno.Command("timew", {
									args: ["continue", `@${id}`, textInput],
								}).outputSync();
								setStatus(
									decoder
										.decode(output.code === 0 ? output.stdout : output.stderr)
										.split("\n")
										.filter((line) => !line.includes("Note:"))
										.at(0) ?? "",
								);
								setTextInput("");
								setState("main");
								setStateData(undefined);
								reloadTimewarriorExport();
							})
							.with({ kind: "stopWithHour" }, () => {
								const output = new Deno.Command("timew", {
									args: ["stop", textInput],
								}).outputSync();
								setStatus(
									decoder
										.decode(output.code === 0 ? output.stdout : output.stderr)
										.split("\n")
										.filter((line) => !line.includes("Note:"))
										.at(0) ?? "",
								);
								setTextInput("");
								setState("main");
								setStateData(undefined);
								reloadTimewarriorExport();
							})
							.run();
					} catch {
						// ignore errors
					}
				})

				.with({ key: { return: true }, state: "selectTask" }, () => {
					setState("selectManualTask");
				})
				.with(
					{ input: P.string.regex(/[a-pr-zA-PR-Z]/), state: "selectTask" },
					({ input }) => {
						const foundSpecialTask = selectedTask?.special_tasks?.find(
							({ shortcut }) => shortcut === input,
						);

						if (foundSpecialTask) {
							try {
								match(stateData)
									.with({ kind: "replace" }, ({ tag, id }) => {
										const output = new Deno.Command("timew", {
											args: [
												"retag",
												`@${id}`,
												`${tag}-${foundSpecialTask.task}`,
											],
										}).outputSync();
										setStatus(
											decoder
												.decode(
													output.code === 0 ? output.stdout : output.stderr,
												)
												.split("\n")
												.filter((line) => !line.includes("Note:"))
												.at(0) ?? "",
										);
										setState("main");
										setStateData(undefined);
										reloadTimewarriorExport();
									})
									.with({ kind: "newWithHour" }, (stateData) => {
										setStateData({
											...stateData,
											task: foundSpecialTask.task,
										});
										setState("selectHour");
									})
									.with({ kind: "new" }, ({ tag }) => {
										const output = new Deno.Command("timew", {
											args: ["start", `${tag}-${foundSpecialTask.task}`],
										}).outputSync();
										setStatus(
											decoder
												.decode(
													output.code === 0 ? output.stdout : output.stderr,
												)
												.split("\n")
												.filter((line) => !line.includes("Note:"))
												.at(0) ?? "",
										);
										setState("main");
										setStateData(undefined);
										reloadTimewarriorExport();
									})
									.run();
							} catch {
								// ignore errors
							}
						}
					},
				)
				.with(
					{ input: P.string.regex(/[a-pr-zA-PR-Z]/), state: "select" },
					({ input }) => {
						const foundTask = tasks.find(({ shortcut }) => shortcut === input);

						if (foundTask) {
							setSelectedTask(foundTask);
							setStateData(
								(previousData) =>
									({
										...(previousData ?? {}),
										tag: foundTask.tag,
									}) as TaskData,
							);
							setState("selectTask");
						}
					},
				)
				.with(
					{ input: "j", state: "main" },
					{ key: { downArrow: true }, state: "main" },
					() => {
						setRow((previousRow) => (previousRow + 1) % maxTasks);
					},
				)
				.with(
					{ input: "k", state: "main" },
					{ key: { upArrow: true }, state: "main" },
					() => {
						setRow((previousRow) => (maxTasks + previousRow - 1) % maxTasks);
					},
				)
				.with({ input: "n", state: "main" }, () => {
					setState("select");
					setStateData({
						kind: "new",
						tag: "",
					});
				})
				.with({ input: "N", state: "main" }, () => {
					setState("select");
					setStateData({
						kind: "newWithHour",
						tag: "",
						hour: "",
						task: "",
					});
				})
				.with({ input: "e", state: "main" }, () => {
					const output = new Deno.Command("timew", {
						args: ["start"],
					}).outputSync();
					setStatus(decoder.decode(output.stdout).split("\n").at(0) ?? "");
					reloadTimewarriorExport();
				})
				.with({ input: "E", state: "main" }, () => {
					setStateData({ kind: "newEmptyWithHour" });
					setState("selectHour");
				})
				.with({ input: "c", state: "main" }, () => {
					const timeEntryAtRow = timeEntries.at(row);

					if (timeEntryAtRow) {
						const output = new Deno.Command("timew", {
							args: ["continue", `@${timeEntryAtRow.id}`],
						}).outputSync();
						setStatus(decoder.decode(output.stdout).split("\n").at(0) ?? "");
						reloadTimewarriorExport();
					}
				})
				.with({ input: "C", state: "main" }, () => {
					const timeEntryAtRow = timeEntries.at(row);

					if (timeEntryAtRow) {
						setState("selectHour");
						setStateData({
							kind: "continueWithHour",
							id: timeEntryAtRow.id,
						});
					}
				})
				.with({ input: "d", state: "main" }, () => {
					const timeEntryAtRow = timeEntries.at(row);

					if (timeEntryAtRow) {
						setState("confirm");
						setStateData({
							kind: "confirmDelete",
							id: timeEntryAtRow.id,
						});
					}
				})
				.with({ input: "s", state: "main" }, () => {
					const output = new Deno.Command("timew", {
						args: ["stop"],
					}).outputSync();
					setStatus(decoder.decode(output.stdout).split("\n").at(0) ?? "");
					reloadTimewarriorExport();
				})
				.with({ input: "S", state: "main" }, () => {
					const timeEntryAtRow = timeEntries.at(row);

					if (timeEntryAtRow) {
						setState("selectHour");
						setStateData({
							kind: "stopWithHour",
						});
					}
				})
				.with({ input: "r", state: "main" }, () => {
					const timeEntryAtRow = timeEntries.at(row);

					if (timeEntryAtRow) {
						setState("select");
						setStateData({
							kind: "replace",
							id: timeEntryAtRow.id,
							tag: "",
						});
					}
				})
				.with({ input: "u", state: "main" }, () => {
					const output = new Deno.Command("timew", {
						args: ["undo"],
					}).outputSync();
					setStatus(decoder.decode(output.stdout).split("\n").at(0) ?? "");
					reloadTimewarriorExport();
				})

				.with({ isQuit: true, state: "selectTask" }, () => {
					setState("select");
				})
				.with({ isQuit: true, state: "select" }, () => {
					setState("main");
				})
				.with({ isQuit: true, state: "main" }, () => {
					app.exit();
				})
				.run();
		} catch {
			// don't handle unmatched keys
		}
	});

	if (error) {
		return (
			<Box width={columns} height={rows} flexDirection="column">
				<Text>{error.stack}</Text>
			</Box>
		);
	}

	return (
		<Box width={columns} height={rows} flexDirection="column">
			<Box borderStyle="single">
				<Text>
					{match(state)
						.with("confirm", () =>
							match(stateData)
								.with(
									{ kind: "confirmDelete" },
									() => "Are you sure you want to delete this task? [y/n]",
								)
								.otherwise(() => ""),
						)
						.with("selectManualTask", () => `Enter task number: ${textInput}`)
						.with(
							"selectHour",
							() =>
								`Enter hour: ${textInput.length >= 2 ? `${textInput.slice(0, 2)}:${textInput.slice(2)}` : textInput}`,
						)
						.otherwise(() => status)}
				</Text>
			</Box>
			<Box borderStyle="single" flexGrow={1} flexDirection="column">
				{(state === "main" ||
					state === "confirm" ||
					(state === "selectHour" &&
						(stateData?.kind === "continueWithHour" ||
							stateData?.kind === "stopWithHour" ||
							stateData?.kind === "newEmptyWithHour"))) && (
					<>
						<Box flexDirection="row" gap={1}>
							<Box flexGrow={1}>
								<Text> TASK </Text>
							</Box>
							<Box width={24} justifyContent="flex-end">
								<Text> START </Text>
							</Box>
							<Box width={24} justifyContent="flex-end">
								<Text> END </Text>
							</Box>
						</Box>
						{timeEntries.map(({ id, start, end, tags }, index) => (
							<Box key={id} flexDirection="row" gap={1}>
								<Box flexGrow={1}>
									<Text inverse={index === row}>
										{" "}
										{tags?.join(", ") || "-"}{" "}
									</Text>
								</Box>
								<Box width={24} justifyContent="flex-end">
									<Text inverse={index === row}> {start || "-"} </Text>
								</Box>
								<Box width={24} justifyContent="flex-end">
									<Text inverse={index === row}> {end || "TRACKING"} </Text>
								</Box>
							</Box>
						))}
					</>
				)}

				{state === "select" &&
					tasks.map(({ shortcut, description }) => (
						<Text key={shortcut}>
							{shortcut}: {description}
						</Text>
					))}

				{(state === "selectTask" ||
					(state === "selectHour" &&
						stateData?.kind !== "continueWithHour" &&
						stateData?.kind !== "stopWithHour" &&
						stateData?.kind !== "newEmptyWithHour") ||
					state === "selectManualTask") &&
					selectedTask && (
						<>
							{selectedTask.special_tasks?.map(({ shortcut, description }) => (
								<Text key={shortcut}>
									{shortcut}: {description}
								</Text>
							))}
							<Text>Enter: custom task</Text>
						</>
					)}
			</Box>
			{state === "main" && (
				<Box borderStyle="single">
					<Text>{instructions.join(", ")}</Text>
				</Box>
			)}
		</Box>
	);
}

Deno.stdout.write(encoder.encode(enterAltScreenCommand));
render(<TimewarriorPopup />);

#!/usr/bin/env -S deno run --allow-env --allow-run

const getCommand = new Deno.Command("ddcutil", {
	args: ["getvcp", "10", "-t"],
	stdin: "null",
	stderr: "null",
});

const textDecoder = new TextDecoder();

const currentBrightness = textDecoder
	.decode(getCommand.outputSync().stdout)
	.split(/\s+/)
	.at(3);

const newBrightness = currentBrightness === "50" ? "100" : "50";

const setCommand = new Deno.Command("ddcutil", {
	args: ["setvcp", "10", newBrightness],
	stdin: "null",
	stderr: "null",
});

setCommand.output();

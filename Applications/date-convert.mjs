#!/usr/bin/env -S deno run

import { DateTime } from "npm:luxon@3.3.0";
import { parse } from "https://deno.land/std@0.184.0/flags/mod.ts";

try {
  const {
    i,
    o,
    input,
    output,
    _: [rawDate],
  } = parse(Deno.args);

  const inputFormat = i || input;
  const outputFormat = o || output;

  const inputDate = inputFormat
    ? DateTime.fromFormat(rawDate, inputFormat)
    : DateTime.fromISO(rawDate);

  if (!inputDate.isValid) {
    throw new Error(`Invalid date produced from "${rawDate}"`);
  }

  Deno.stdout.write(
    new TextEncoder().encode(
      outputFormat ? inputDate.toFormat(outputFormat) : inputDate.toISO()
    )
  );
  Deno.exit(0);
} catch (error) {
  Deno.stderr.write(new TextEncoder().encode(`❎ ${error.message}\n`));
  Deno.exit(1);
}

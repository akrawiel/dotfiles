#!/usr/bin/env -S deno run

import { DateTime } from "npm:luxon@3.3.0";
import { parse } from "https://deno.land/std@0.184.0/flags/mod.ts";

try {
  const {
    _: [rawDateArray],
  } = parse(Deno.args);

  const dateArray = JSON.parse(rawDateArray)

  const outputFormat = "LLLdd HH:mm:ss";

  const parsedDateArray = dateArray.map(({ from, to }) => {
    const fromDateTime = DateTime.fromISO(from);
    const toDateTime = DateTime.fromISO(to);

    return {
      from: fromDateTime.isValid ? fromDateTime.toFormat(outputFormat) : null,
      to: toDateTime.isValid ? toDateTime.toFormat(outputFormat) : null,
    };
  });

  Deno.stdout.write(new TextEncoder().encode(JSON.stringify(parsedDateArray)));
  Deno.exit(0);
} catch (error) {
  Deno.stderr.write(new TextEncoder().encode(`❎ ${error.message}\n`));
  Deno.exit(1);
}

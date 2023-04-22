#!/usr/bin/env node

// Luxon 3.3.0 for Node
import { DateTime, Duration } from "./luxon.js";

import { promisify } from "node:util";
import { exec as execWithCallback } from "node:child_process";

const exec = promisify(execWithCallback);

const { stdout: rawTokenData, stderr: rawAttributes } = await exec(
  "secret-tool search service jira-cli"
);
const { stdout: rawExportData } = await exec("timew export today");

const exportData = JSON.parse(rawExportData);

const {
  secret,
  "attribute.domain": domain,
  "attribute.username": username,
} = Object.fromEntries(
  rawTokenData
    .concat("\n")
    .concat(rawAttributes)
    .split("\n")
    .filter(Boolean)
    .map((value) => value.split(" = "))
    .filter((fieldData) => fieldData.length === 2)
);

console.table(exportData);

try {
  if (exportData.length === 0)
    throw new Error(`❎ No time reports found for today`);

  for (const { start, end, id } of exportData) {
    if (!start) throw new Error(`❎ No start time for @${id}`);
    if (!end) throw new Error(`❎ No end time for @${id}`);
  }

  for (const { start: startString, end: endString, id, tags } of exportData) {
    if (!tags) throw new Error(`❎ No tags found for @${id}`);

    const tag = tags.find((tag) => /^[a-zA-Z]+-\d+$/.test(tag));

    if (!tag)
      throw new Error(
        `❎ No valid tag found for @${id}, available tags: ${tags.join(", ")}`
      );

    const start = DateTime.fromISO(startString);
    const end = DateTime.fromISO(endString);

    if (!start.isValid)
      throw new Error(`❎ Start value invalid for @${id} - ${startString}`);
    if (!end.isValid)
      throw new Error(`❎ End value invalid for @${id} - ${endString}`);

    const { seconds: secondsSpent } = end.diff(start, "seconds").toObject();

    if (!secondsSpent || secondsSpent <= 0)
      throw new Error(
        `❎ Invalid difference value for @${id} - ${secondsSpent}`
      );

    const response = await fetch(
      `https://${domain}/rest/api/3/issue/${tag}/worklog`,
      {
        method: "POST",
        headers: {
          Authorization: `Basic ${Buffer.from(`${username}:${secret}`).toString(
            "base64"
          )}`,
          Accept: "application/json",
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          started: start.toFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZZZ"),
          timeSpentSeconds: secondsSpent,
        }),
      }
    );

    if (!response.ok) {
      const errorText = await response.text();

      throw new Error(
        `❎ Worklog adding for ${tag} failed with error ${response.status}: ${errorText}`
      );
    }

    console.log(
      `✅ Worklog added for ${tag} -> ${start.toLocaleString(
        DateTime.DATETIME_SHORT_WITH_SECONDS
      )} for ${Duration.fromObject({ seconds: secondsSpent })
        .rescale()
        .toHuman()}`
    );
  }

  console.log("✅ Time report sent successfully");
} catch (error) {
  console.log(error.message);
}

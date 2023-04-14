#!/usr/bin/env zx

$.verbose = false;
// amixer | tail -n1 | sed -E 's/.*\[(on|off)\]/\1/'
const micStatus = await $`amixer | tail -n1`;
const micSatusOff = micStatus.stdout.includes("[off]");

if (micSatusOff) {
  await echo`<fc=#e06c75><fn=5></fn></fc>`;
} else {
  await echo`<fn=6></fn>`;
}

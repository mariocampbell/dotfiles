#!/usr/bin/env zx

$.verbose = false;
const { toggle, status } = argv;

// $`amixer set Capture toggle | tail -n1 | sed -E 's/.*\[(on|off)\]/\1/'`;
if (toggle) {
  const mic = await $`amixer set Capture toggle | tail -n1`;
  const isOff = mic.stdout.includes("[off]");

  await $`dunstify "" -u low -t 1500 -i ~/dotfiles/icons/fontawesome/microphone${
    isOff ? "-mute" : ""
  }.svg -r 100811`;

  await $`paplay ~/dotfiles/sounds/discord-${
    isOff ? "un" : ""
  }mute-mic.ogg --volume 60000`;
}

// amixer | tail -n1 | sed -E 's/.*\[(on|off)\]/\1/'
if (status) {
  const micStatus = await $`amixer | tail -n1`;
  const micSatusOff = micStatus.stdout.includes("[off]");

  if (micSatusOff) {
    await echo`<fc=#e06c75><fn=5></fn></fc>`;
  } else {
    await echo`<fn=6></fn>`;
  }
}

if (!status && !toggle) console.log(chalk.red("Debe ingresar un parametro."));

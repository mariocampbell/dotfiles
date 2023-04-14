#!/usr/bin/env zx

$.verbose = false;
const layout = await $`setxkbmap -query | grep layout`;
const languaje = (await layout.stdout.includes("us")) ? "es" : "us";

$`setxkbmap ${languaje}`;
$`dunstify "" -u low -t 1500 -i ~/dotfiles/icons/fontawesome/lan-${languaje}.svg -r 100818`;

#!/bin/dash

# Cheers to ChadWM (https://github.com/siduck/chadwm) from where I stole basically this entire script.

# colors

black=#29353B
green=#89b482
white=#c7b89d
grey=#29353B
blue=#6f8faf
red=#ec6b64
darkblue=#6080a0

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

cpu() {
	cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

	printf "^c$black^ ^b$green^ CPU"
	printf "^c$white^ ^b$grey^ $cpu_val"
}

mem() {
	printf "^c$blue^^b$black^  "
	printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^  ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^  ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^   "
	printf "^c$black^^b$blue^ $(date '+%I:%M %p')  "
}

while true; do

	[ $interval = 0 ] || [ $(($interval % 3600)) = 0 ]
	interval=$((interval + 1))

	sleep 1 && xsetroot -name "$(cpu) $(mem) $(wlan) $(clock)"
done

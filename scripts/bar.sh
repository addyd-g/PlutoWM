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

	printf "^c$black^ ^b$green^ "
	printf "^c$black^ ^b$green^ $cpu_val"
}

mem() {
	printf "^c$blue^^b$black^  "
	printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

pkg_updates() {
	# updates=$(doas xbps-install -un | wc -l) # void
	updates=$(checkupdates-aur | wc -l)   # arch , needs pacman contrib
	# updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

	if [ -z "$updates" ]; then
		printf "^b$black^^c$darkblue^  Fully Updated"
	else
		printf "^b$black^^c$blue^  $updates"" updates"
	fi
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^  Connected" ;;
	down) printf "^c$black^ ^b$red^  Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$green^ "
	printf "^c$black^^b$green^ $(date '+%H:%M')  "
}


while true; do

	[ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
	interval=$((interval + 1))

	sleep 1 && xsetroot -name " $(cpu) $(mem) $(wlan) $updates $(clock)"
done
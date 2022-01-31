#!/bin/dash

# Cheers to ChadWM (https://github.com/siduck/chadwm) from where I stole basically this entire script.

# colors

black=#29353B
green=#89b482
white=#c7b89d
grey=#222D32
blue=#6f8faf
red=#ec6b64
yellow=#CDF51D

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

spacer() {
	printf "^c$black^ ^b$black^ "
}

cpu() {
	cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

	printf "^c$green^ ^b$grey^  $cpu_val"
}

mem() {
	printf "^c$blue^^b$grey^  "
	printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

pkg_updates() {
	# updates=$(doas xbps-install -un | wc -l) # void
	updates=$(checkupdates-aur | wc -l)   # arch , needs pacman contrib
	# updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

	if [ -z "$updates" ]; then
		printf "^b$grey^^c$blue^  No Updates"
	else
		printf "^b$grey^^c$yellow^  $updates"" Updates"
	fi
}

wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$blue^ ^b$grey^  Connected" ;;
	down) printf "^c$red^ ^b$grey^  Disconnected" ;;
	esac
}

clock() {
	printf "^c$green^ ^b$grey^ "
	printf "^c$green^^b$grey^ $(date '+%H:%M')  "
}


while true; do

	[ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
	interval=$((interval + 1))

	sleep 1 && xsetroot -name " $(cpu) $(spacer) $(mem) $(spacer) $(wlan) $(spacer) $updates $(spacer) $(clock)"
done
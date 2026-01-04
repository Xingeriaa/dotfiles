#!/bin/sh

# -e: exit on error
# -u: exit on unset variables
set -eu

if ! chezmoi="$(command -v chezmoi)"; then
	bin_dir="${HOME}/.local/bin"
	chezmoi="${bin_dir}/chezmoi"
	echo "Installing chezmoi to '${chezmoi}'" >&2
	if command -v curl >/dev/null; then
		chezmoi_install_script="$(curl -fsSL get.chezmoi.io)"
	elif command -v wget >/dev/null; then
		chezmoi_install_script="$(wget -qO- get.chezmoi.io)"
	else
		echo "To install chezmoi, you must have curl or wget installed." >&2
		exit 1
	fi
	sh -c "${chezmoi_install_script}" -- -b "${bin_dir}"
	unset chezmoi_install_script bin_dir
fi

# POSIX way to get script's dir: https://stackoverflow.com/a/29834779/12156188
script_dir="$(cd -P -- "$(dirname -- "$(command -v -- "$0")")" && pwd -P)"

prompt_default() {
	prompt="$1"
	default="$2"

	if [ -n "$default" ]; then
		printf "%s [%s]: " "$prompt" "$default"
	else
		printf "%s: " "$prompt"
	fi

	read -r reply
	if [ -z "$reply" ]; then
		reply="$default"
	fi

	printf "%s" "$reply"
}

to_lower() {
	printf "%s" "$1" | tr '[:upper:]' '[:lower:]'
}

parse_res() {
	case "$1" in
		*x*)
			width="${1%x*}"
			height="${1#*x}"
			;;
		*)
			return 1
			;;
	esac

	case "$width" in
		''|*[!0-9]*)
			return 1
			;;
	esac

	case "$height" in
		''|*[!0-9]*)
			return 1
			;;
	esac

	printf "%s %s" "$width" "$height"
}

get_monitor_by_index() {
	idx="$1"
	set -- $monitor_names
	i=1
	for name in "$@"; do
		if [ "$i" -eq "$idx" ]; then
			printf "%s" "$name"
			return 0
		fi
		i=$((i + 1))
	done
	return 1
}

setup_monitors() {
	monitors_file="${script_dir}/dot_config/hypr/monitors.conf"

	printf "%s\n" "Dotfiles monitor setup"
	printf "%s\n" "Tip: monitor names can be seen via: hyprctl monitors | wlr-randr | xrandr"
	printf "\n"

	if command -v hyprctl >/dev/null; then
		printf "%s\n" "Detected monitors (hyprctl monitors):"
		hyprctl monitors || true
		printf "\n"
	elif command -v wlr-randr >/dev/null; then
		printf "%s\n" "Detected monitors (wlr-randr):"
		wlr-randr || true
		printf "\n"
	elif command -v xrandr >/dev/null; then
		printf "%s\n" "Detected monitors (xrandr --query):"
		xrandr --query || true
		printf "\n"
	fi

	profile="$(prompt_default "Profile (laptop/desktop/custom)" "desktop")"
	profile="$(to_lower "$profile")"

	case "$profile" in
		laptop)
			default_count=1
			;;
		desktop)
			default_count=2
			;;
		*)
			default_count=1
			;;
	esac

	monitor_count="$(prompt_default "How many monitors?" "$default_count")"

	monitor_lines=""
	workspace_lines=""
	monitor_names=""

	i=1
	primary_width=""
	primary_height=""

	while [ "$i" -le "$monitor_count" ]; do
		name="$(prompt_default "Monitor #${i} name (ex: DP-1, eDP-1)" "")"

		res=""
		while [ -z "$res" ]; do
			res="$(prompt_default "Monitor #${i} resolution (ex: 1920x1080)" "")"
			if ! parse_res "$res" >/dev/null; then
				printf "%s\n" "Invalid resolution format. Use WIDTHxHEIGHT (ex: 2560x1440)."
				res=""
			fi
		done

		refresh="$(prompt_default "Monitor #${i} refresh rate (Hz)" "60")"
		scale="$(prompt_default "Monitor #${i} scale" "1")"

		set -- $(parse_res "$res")
		width="$1"
		height="$2"

		if [ "$i" -eq 1 ]; then
			x=0
			y=0
			primary_width="$width"
			primary_height="$height"
		else
			position="$(prompt_default "Position relative to primary (left/right/up/down/custom)" "right")"
			position="$(to_lower "$position")"

			case "$position" in
				left)
					x=$((0 - width))
					y=0
					;;
				right)
					x="$primary_width"
					y=0
					;;
				up)
					x=0
					y=$((0 - height))
					;;
				down)
					x=0
					y="$primary_height"
					;;
				custom)
					x="$(prompt_default "Custom X position" "0")"
					y="$(prompt_default "Custom Y position" "0")"
					;;
				*)
					printf "%s\n" "Unknown position. Defaulting to right."
					x="$primary_width"
					y=0
					;;
			esac
		fi

		monitor_lines="${monitor_lines}monitor=${name},${res}@${refresh},${x}x${y},${scale}\n"
		monitor_names="${monitor_names} ${name}"

		i=$((i + 1))
	done

	i=1
	while [ "$i" -le 10 ]; do
		idx=$(( (i - 1) % monitor_count + 1 ))
		monitor_name="$(get_monitor_by_index "$idx")"
		workspace_lines="${workspace_lines}workspace = ${i},monitor:${monitor_name}\n"
		i=$((i + 1))
	done

	tmp_file="${monitors_file}.tmp"
	{
		printf "%s\n" "### MONITORS ###"
		printf "%b" "$monitor_lines"
		printf "\n"
		printf "%b" "$workspace_lines"
	} > "$tmp_file"

	mv "$tmp_file" "$monitors_file"

	printf "%s\n" "Wrote ${monitors_file}"
}

post_install() {
	config_dir="${HOME}/.config"

	for path in \
		"${config_dir}/waybar/scripts/external-brightness.sh" \
		"${config_dir}/waybar/scripts/updates-pacman-aur.sh" \
		"${config_dir}/bemenu/run.sh" \
		"${config_dir}/wofi/wofi-power-menu.sh"; do
		if [ -f "$path" ] && [ -w "$path" ]; then
			chmod +x "$path"
		fi
	done

	wallpaper="${config_dir}/hypr/wallpaper.jpg"
	if [ -f "$wallpaper" ] && command -v swww >/dev/null; then
		if swww query >/dev/null 2>&1; then
			swww img "$wallpaper" || true
		else
			echo "swww daemon not running; wallpaper will be set on next session." >&2
		fi
	fi

	if [ "$(id -u)" -eq 0 ] && [ -n "${SUDO_USER:-}" ] && command -v getent >/dev/null; then
		target_home="$(getent passwd "$SUDO_USER" | cut -d: -f6)"
		if [ -n "$target_home" ]; then
			chown -R "$SUDO_USER:$SUDO_USER" \
				"$target_home/.config/hypr" \
				"$target_home/.config/waybar" \
				"$target_home/.config/bemenu" \
				"$target_home/.config/wofi" 2>/dev/null || true
		fi
	fi
}

set -- init --apply --source="${script_dir}"

echo "Running 'chezmoi $*'" >&2
"$chezmoi" "$@"

post_install

run_monitor_setup="$(prompt_default "Configure monitors now? (y/n)" "y")"
run_monitor_setup="$(to_lower "$run_monitor_setup")"
if [ "$run_monitor_setup" = "y" ] || [ "$run_monitor_setup" = "yes" ]; then
	setup_monitors

	apply_now="$(prompt_default "Run 'chezmoi apply' to apply monitor changes? (y/n)" "y")"
	apply_now="$(to_lower "$apply_now")"
	if [ "$apply_now" = "y" ] || [ "$apply_now" = "yes" ]; then
		"$chezmoi" apply --source="${script_dir}"
	fi
fi

#!/bin/bash

# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present AmberELEC (https://github.com/AmberELEC)

. /etc/profile

echo 'starting retrorun emulator...'

CORE="$1"
ROM="${2##*/}"
PLATFORM="$3"
CONF="/storage/.config/distribution/configs/distribution.conf"
RRCONF="/storage/.config/distribution/configs/retrorun.cfg"

if [ ! -f ${RRCONF} ]; then
  cp -f /usr/config/distribution/configs/retrorun.cfg /storage/.config/distribution/configs/
fi

function get_setting() {
	#We look for the setting on the ROM first, if not found we search for platform and lastly we search globally
	PAT="s|^${PLATFORM}\[\"${ROM}\"\].*${1}=\(.*\)|\1|p"
	EES=$(sed -n "${PAT}" "${CONF}" | head -1)

	if [ -z "${EES}" ]; then
		PAT="s|^${PLATFORM}[\.-]${1}=\(.*\)|\1|p"
		EES=$(sed -n "${PAT}" "${CONF}" | head -1)
	fi

	if [ -z "${EES}" ]; then
		PAT="s|^global[\.-].*${1}=\(.*\)|\1|p"
		EES=$(sed -n "${PAT}" "${CONF}" | head -1)
	fi

	[ -z "${EES}" ] && EES="false"
}

### GLOBAL SETTINGS

# Auto Save
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "auto_save"
echo ${EES}
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_auto_save/d" ${RRCONF}
	echo 'retrorun_auto_save = false' >> ${RRCONF}
else
	sed -i "/^retrorun_auto_save/d" ${RRCONF}
	echo "retrorun_auto_save = ${EES}" >> ${RRCONF}
fi

# Map left analog to DPAD
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "map_left_analog_to_dpad"
echo ${EES}
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
        sed -i "/^retrorun_force_left_analog_stick/d" ${RRCONF}
        echo 'retrorun_force_left_analog_stick = false' >> ${RRCONF}
else
        sed -i "/^retrorun_force_left_analog_stick/d" ${RRCONF}
        echo "retrorun_force_left_analog_stick = ${EES}" >> ${RRCONF}
fi

# Game Aspect Ratio
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "game_aspect_ratio"
echo ${EES}
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_aspect_ratio/d" ${RRCONF}
	echo 'retrorun_aspect_ratio = auto' >> ${RRCONF}
else
	sed -i "/^retrorun_aspect_ratio/d" ${RRCONF}
	echo "retrorun_aspect_ratio = ${EES}" >> ${RRCONF}
fi

# Show FPS
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "show_fps"
echo ${EES}
if [ "${EES}" == "auto" ] || [ "${EES}" == "disabled" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	sed -i "/^retrorun_fps_counter/d" ${RRCONF}
	echo 'retrorun_fps_counter = disabled' >> ${RRCONF}
else
	sed -i "/^retrorun_fps_counter/d" ${RRCONF}
	echo "retrorun_fps_counter = ${EES}" >> ${RRCONF}
fi

# Video Another Thread
if [[ "$EE_DEVICE" == "RG552" ]]; then
	VIDEO_ANOTHER_THREAD='true' # this is better on RG552
else
	VIDEO_ANOTHER_THREAD='half'
fi
sed -i "/^retrorun_video_another_thread/d" ${RRCONF}
echo "retrorun_video_another_thread = ${VIDEO_ANOTHER_THREAD}" >> ${RRCONF}

# Adaptive FPS (it helps on 351 devices)
if [[ "$EE_DEVICE" == "RG552" ]]; then
	ADAPTIVE_FPS='false'
else
	ADAPTIVE_FPS='true'
fi
sed -i "/^retrorun_adaptive_fps/d" ${RRCONF}
echo "retrorun_adaptive_fps = ${ADAPTIVE_FPS}" >> ${RRCONF}


### CORE SETTINGS

# Internal Resolution
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "internal_resolution"
echo ${EES}
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" =~ "parallel_n64" ]]; then
		sed -i "/^parallel-n64-screensize/d" ${RRCONF}
		echo 'parallel-n64-screensize = 640x480' >> ${RRCONF}
	elif [[ "${CORE}" =~ "flycast" ]]; then
		sed -i "/^flycast_internal_resolution/d" ${RRCONF}
		echo 'flycast_internal_resolution = 640x480' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" =~ "parallel_n64" ]]; then
		sed -i "/^parallel-n64-screensize/d" ${RRCONF}
		echo "parallel-n64-screensize = ${EES}" >> ${RRCONF}
	elif [[ "${CORE}" =~ "flycast" ]]; then
		sed -i "/^flycast_internal_resolution/d" ${RRCONF}
		echo "flycast_internal_resolution = ${EES}" >> ${RRCONF}
	fi
fi

# Parallel-N64 Graphic plug-in
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "gfx_plugin"
echo ${EES}
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" =~ "parallel_n64" ]]; then
		sed -i "/^parallel-n64-gfxplugin/d" ${RRCONF}
		echo 'parallel-n64-gfxplugin = rice' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" =~ "parallel_n64" ]]; then
		sed -i "/^parallel-n64-gfxplugin/d" ${RRCONF}
		echo "parallel-n64-gfxplugin = ${EES}" >> ${RRCONF}
	fi
fi

# Parallel-N64 Overclock
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "overclock"
echo ${EES}
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" =~ "parallel_n64" ]]; then
		sed -i "/^parallel-n64-virefresh/d" ${RRCONF}
		echo 'parallel-n64-virefresh = auto' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" =~ "parallel_n64" ]]; then
		sed -i "/^parallel-n64-virefresh/d" ${RRCONF}
		echo "parallel-n64-virefresh = ${EES}" >> ${RRCONF}
	fi
fi

# Parallel-N64 Audio buffer size
if [[ "$EE_DEVICE" == "RG552" ]]; then
	AUDIO_BUFFER='2048'
else
	AUDIO_BUFFER='1024'
fi
sed -i "/^parallel-n64-audio-buffer-size/d" ${RRCONF}
echo "parallel-n64-audio-buffer-size = ${AUDIO_BUFFER}" >> ${RRCONF}

# Synchronous Rendering
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "synchronous_rendering"
echo ${EES}
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" =~ "flycast" ]]; then
		sed -i "/^flycast_synchronous_rendering/d" ${RRCONF}
		echo 'flycast_synchronous_rendering = disabled' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" =~ "flycast" ]]; then
		sed -i "/^flycast_synchronous_rendering/d" ${RRCONF}
		echo "flycast_synchronous_rendering = ${EES}" >> ${RRCONF}
	fi
fi

# Map left analog to DPAD
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "div_matching"
echo ${EES}
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
        sed -i "/^flycast_div_matching/d" ${RRCONF}
        echo 'flycast_div_matching = auto' >> ${RRCONF}
else
        sed -i "/^flycast_div_matching/d" ${RRCONF}
        echo "flycast_div_matching = ${EES}" >> ${RRCONF}
fi

# PSX CPU Clock
# Get configuration from distribution.conf and set to retrorun.cfg
get_setting "psx_cpu_clock"
echo ${EES}
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" =~ "pcsx_rearmed" ]]; then
		sed -i "/^pcsx_rearmed_psxclock/d" ${RRCONF}
		echo 'pcsx_rearmed_psxclock = 57' >> ${RRCONF}
	fi
else
	if [[ "${CORE}" =~ "pcsx_rearmed" ]]; then
		sed -i "/^pcsx_rearmed_psxclock/d" ${RRCONF}
		echo "pcsx_rearmed_psxclock = ${EES}" >> ${RRCONF}
	fi
fi

# Flycast Auto Frameskip
# Get configuration from distribution.conf and set to retrorun.cfg
# default value for flycast_auto_skip_frame it's 'some'
if [[ "$EE_DEVICE" == "RG552" ]]; then
	DEFAULT_AUTO_SKIP_FRAME='disabled' # this is better on RG552
else
	DEFAULT_AUTO_SKIP_FRAME='some'
fi
get_setting "auto_frameskip"
echo ${EES}
if [ "${EES}" == "auto" ] || [ "${EES}" == "false" ] || [ "${EES}" == "none" ] || [ "${EES}" == "0" ]; then
	if [[ "${CORE}" =~ "flycast" ]]; then
		sed -i "/^flycast_auto_skip_frame/d" ${RRCONF}
		echo "flycast_auto_skip_frame = ${DEFAULT_AUTO_SKIP_FRAME}" >> ${RRCONF}
	fi
else
	if [[ "${CORE}" =~ "flycast" ]]; then
		sed -i "/^flycast_auto_skip_frame/d" ${RRCONF}
		echo "flycast_auto_skip_frame = ${EES}" >> ${RRCONF}
	fi
fi

rm /dev/input/by-path/platform-odroidgo2-joypad-event-joystick || true
echo 'creating fake joypad'
/usr/bin/rg351p-js2xbox --silent -t oga_joypad &
sleep 0.2
echo 'confguring inputs'
EE_DEVICE=$(cat /storage/.config/.OS_ARCH)
echo 'confguring inputs on device:'$EE_DEVICE
if [[ "$EE_DEVICE" == "RG351V" ]] || [[ "$EE_DEVICE" == "RG351MP" ]]
then
	ln -s /dev/input/event4 /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
else
	ln -s /dev/input/event3 /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
fi
chmod 777 /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
echo 'using core:' "$1"
echo 'platform:' "$3"
echo 'starting game:' "$2"

FPS=''
if [[ "$4" == "show_fps" ]] || [[ "$4" == "SHOW_FPS" ]]
then
    echo 'enabling FPS in the logs'
    FPS="-f"
fi
GPIO_JOYPAD=''
if [[ "$EE_DEVICE" == "RG351MP" ]] || [[ "$EE_DEVICE" == "RG552" ]]
then
    echo 'GPIO joypad'
    GPIO_JOYPAD="-g"
fi

sleep 0.2
if [[ "$1" =~ "pcsx_rearmed" ]] || [[ "$1" =~ "parallel_n64" ]]
then
    echo 'using 32bit'
  	export LD_LIBRARY_PATH="/usr/lib32"
	/usr/bin/retrorun32 --triggers $FPS $GPIO_JOYPAD -s /storage/roms/"$3" -d /roms/bios "$1" "$2"
else
	echo 'using 64bit'
	/usr/bin/retrorun --triggers $FPS $GPIO_JOYPAD -s /storage/roms/"$3" -d /roms/bios "$1" "$2"
fi
sleep 0.5
rm /dev/input/by-path/platform-odroidgo2-joypad-event-joystick
kill $(pidof rg351p-js2xbox)
echo 'end!'
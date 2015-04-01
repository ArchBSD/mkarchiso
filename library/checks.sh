is_mount_point() {
	check=$1
	if ( df ${check} | grep -q ${check} ); then 	
		return 0 
	else
		return 1
	fi
}

is_openrc() {
	[[ "$init" != "openrc" ]] && return 1
}
check_mounted() {
	local potential_mounts=("${iso_root}_i686" "${iso_root}_x86_64" "${iso_root}_i686/etc" "${iso_root}_x86_64/etc"  "${iso_root}_i686/dev" 
		"${iso_root}_x86_64/dev" "${iso_root}_i686/etc_rw" "${iso_root}_x86_64/etc_rw")
	msg "Unmounting FileSystems"
	for mounts in ${potential_mounts[@]}; do
		if ( is_mount_point ${mounts} ); then
			umount ${mounts}
		fi
	done

	if [ -e /dev/md1337 ]; then
		mdconfig -d -u 1337
	fi

	if [ -e /dev/md5 ]; then
		sync
		mdconfig -d -u 5
	fi
}

check_are_we_root() {
	[[ "$UID" != "0" ]] && return 1
}

check_usb() {
	[[ "$create_usb" == "0" ]] && return 0
}

check_iso() {
    [[ "$create_iso" == "0" ]] && return 0
}

check_and_create_dirs() {
	for dirs in ArchBSD_iso_i686 ArchBSD_iso_x86_64 ArchBSD_cache_i686 ArchBSD_cache_x86_64; do
		if [ ! -d "${tmp}/${dirs}" ]; then
			mkdir -p "${tmp}/${dirs}"
		fi
	done

	if ( check_iso ); then
		for dirs in ArchBSD_iso_i686/etc_rw ArchBSD_iso_x86_64/etc_rw; do
			if [ ! -d "${tmp}/${dirs}" ]; then
				mkdir -p "${tmp}/${dirs}"
			fi
		done
	fi
}			

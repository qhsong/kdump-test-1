#!/usr/bin/env bash

# In Fedora and upstream kernel, can't support crashkernel=auto kernel parameter,
# but we can check /sys/kernel/kexec_crash_size value, if equal to zero, so we need
# change kernel parameter crashkernel=<>M or other value

# Copyright (C) 2008 CAI Qian <caiqian@redhat.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
# Update: Qiao Zhao <qzhao@redhat.com>


K_REBOOT="./K_REBOOT"
((INCLUDE_KDUMP_SH)) && return ||INCLUDE_KDUMP_SH=1

############################
# Set up a new kdump env 
# Globals:
#   K_REBOOT
#   K_ARCH
# Arguments:
#   $1 - Set Kernel Aruments, can ignore
# Return:
#   None
#############################
prepare_kdump()
{
  local KERARGS=$1
  if [ ! -f "${K_REBOOT}" ]; then
    local default
    default=/boot/vmlinuz/$(uname -r)
	/sbin/grubby --set-default="${default}"
	
	# for uncompressed kernel, i.e. vmlinux
	[[ ${default} == *vmlinux* ]] && {
		debug "- modifying /etc/sysconfig/kdump properly for 'vmlinux'."
		sed -i 's/\(KDUMP_IMG\)=.*/\1=vmlinux/' /etc/sysconfig/kdump
	}

	# check /sys/kernel/kexec_crash_size value and update if need.
	# need restart system when you change this value.
	grep -q 'crashkernel' <<< "${KERARGS}" || {
		[[ $(cat /sys/kernel/kexec_crash_size) -eq 0 ]] && {
			debug "$(grep MemTotal /proc/meminfo)"
            KERARGS+="$(def_kdump_mem)"
		}
	}
	[ "${KERARGS}" ] && {
		# need create a file/flag to sign we have do this.
		touch ${K_REBOOT}
		debug "- changing boot loader."
		{
			/sbin/grubby	\
				--args="${KERARGS}"	\
				--update-kernel="${default}" &&
			if [[ ${K_ARCH} = "s390x" ]]; then zipl; fi
		} || {
			error "- change boot loader error!"
		}
		debug "prepare reboot."
		reboot_system
	}

  fi
  [ -f "${K_REBOOT}" ] && rm -f "${K_REBOOT}"

  # install kexec-tools package
  rpm -q kexec-tools || yum install -y kexec-tools || echo "kexec-tools install failed."

  # enable kdump service: systemd | sys-v
  /bin/systemctl enable kdump.service || /sbin/chkconfig kdump on
}

############################
# Check vmcore exist.It will do nothing if exist, else exit.
# Globals:
#   K_DEFAULT_PATH
# Arguments:
#   None
# Return:
#   None
#############################
check_vmcore_file()
{
  debug "- get vmcore file"
  local filenum
  filenum=$(find "${K_DEFAULT_PATH}"/*/ -name vmcore| grep -c vmcore )
  if [[ ${filenum} -eq 0 ]];then
    error "Can not find vmcore"
  fi
}


############################
# Restart Kdump
# Globals:
#   None
# Arguments:
#   None
# Return:
#   None
#############################
restart_kdump()
{
	debug "- retart kdump service."
	grep -v ^# "${K_CONFIG}"
	# delete kdump.img in /boot directory
	rm -f /boot/initrd-*kdump.img || rm -f /boot/initramfs-*kdump.img
	/usr/bin/kdumpctl restart 2>&1 | tee /tmp/kdump_restart.log || /sbin/service kdump restart 2>&1 | tee /tmp/kdump_restart.log
    report_file /tmp/kdump_restart.log
	[ $? -ne 0 ] && error "- kdump service start failed."
	debug "- kdump service start normal."
}

# Config default kdump memory
def_kdump_mem()
{
	local args=""
	if [[ "${K_ARCH}" = "x86_64" ]]; then args="crashkernel=160M"
	elif [[ "${K_ARCH}" = "ppc64" ]]; then args="crashkernel=320M"
	elif [[ "${K_ARCH}" = "s390x" ]]; then args="crashkernel=160M"
	elif [[ "${K_ARCH}" = "ppc64le" ]]; then args="crashkernel=320M"
	elif [[ "${K_ARCH}" = "aarch64" ]]; then args="crashkernel=2048M"
	elif [[ "${K_ARCH}" = i?86 ]]; then args="crashkernel=128M"
	fi
	echo "$args"
}

# config kdump.conf
configure_kdump_conf()
{
	# need accepte pramater from user.
	# there will include more branch case, like:
	# config_raw, config_dev_name, config_dev_uuid, config_dev_label, config_nfs, config_ssh, config_ssh_key
	# config_path
	# config_core_collector
	# config_post, config_pre
	# config_extra
	# config_default
	debug "config kdump configuration"
}

config_raw()
{
	echo "config raw"
}

config_dev_name()
{
	echo "config device name"
}

config_dev_uuid()
{
	echo "config device uuid"
}

config_dev_label()
{
	echo "config device label"
}

config_dev_softlink()
{
	echo "config device softlink"
}

config_nfs()
{
	echo "config nfs target"
}

config_nfs_ipv6()
{
	echo "config ipv6 nfs target"
}

config_ssh()
{
	echo "config ssh target"
}

config_ssh_key()
{
	echo "config ssh key"
}

config_ssh_ipv6()
{
	echo "config ipv6 ssh target"
}

config_path()
{
	echo "config path"
}

config_core_collector()
{
	echo "config collector (makedumpfile)"
}

config_post()
{
	echo "config post option"
}

config_pre()
{
	echo "config prepare option"
}

config_extra()
{
	echo "config extra option"
}

config_default()
{
	echo "config default option"
}

############################
# trigger methods, the common methods is 'echo c > /proc/sysrq'
# Globals:
#	None
# Arguments:
#   None
# Return:
#   None
#############################
trigger_echo_c()
{
	echo "c" > /proc/sysrq-trigger
}

trigger_AltSysC()
{
	echo "trigger by AltSysC button"
}

tirgger_kernel_BUG()
{
	echo "trigger by kernel function BUG()"
}

trigger_kernel_panic()
{
	echo "trigger by kernel function panic()"
}

trigger_kernel_lockup()
{
	echo "trigger by hard lockup"
}

trigger_kernel_panic_on_warn()
{
	echo "trigger by kernel function panic_on_warn()"
}

#!/usr/bin/env bash

# Common variable and package for Kdump

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
# Update: Qiao Zhao <qzhao@redhat.com

((INCLUDE_COMMON_SH)) && return ||INCLUDE_COMMON_SH=1

. ../lib/crash.sh
. ../lib/env.sh
. ../lib/kdump.sh
. ../lib/log.sh


readonly K_TESTAREA="/mnt/testarea"
mkdir -p ${K_TESTAREA}
readonly K_NFS="${K_TESTAREA}/KDUMP-NFS"
readonly K_PATH="${K_TESTAREA}/KDUMP-PATH"
readonly K_RAW="${K_TESTAREA}/KDUMP-RAW"
readonly K_CONFIG="/etc/kdump.conf"
readonly K_ARCH="$(uname -m)"
readonly K_KVER="$(uname -r | sed "s/\.$K_ARCH//")"
readonly K_KVARI="$(echo "$K_KVER" | grep -Eo '(debug|PAE|xen|trace|vanilla)$')"
readonly K_KVERS=${K_KVER//\.*${K_KVARI}$/}
readonly K_SSH_CONFIG="${HOME}/.ssh/config"
readonly K_ID_RSA="${SSH_KEY:-/root/.ssh/kdump_id_rsa}"
readonly K_DEFAULT_PATH="/var/crash"
readonly K_ASSETS_FOLDER="../include/assets/"
readonly IS_RT_KEN=false
readonly K_SETUP_KDUMP_FILE="./SETUP"

##############################################
# Do sth. Before Exit
# Globals
#   None
# Arguments:
#   $1 - Error Output Info
# Return:
#   None
##############################################
ready_to_exit()
{
  report_file "${K_CONFIG}"
  report_file "${K_LOG_FILE}"
}

#############################################
# Reboot system
# Globals:
#   None
# Arguments:
#   None
# Return:
#   None
###########################################
reboot_system()
{
  sync
  if is_beaker_env ; then
    rhts-reboot
  else
  reboot
  fi
}

##########################################
# Is Beaker enviroment
# Globals:
#   None
# Arguments:
#   None
# Return:
#   1 - Not a beaker env
#   0 - It a beaker env
#########################################
is_beaker_env()
{
  if [ -z "${TEST}" ]; then
    return 0
  fi
  return 1
}

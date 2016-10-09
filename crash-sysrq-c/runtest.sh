#!/usr/bin/env bash

# Test  [KG-KDUMP-R] "echo c > /proc/sysrq-trigger"

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

. ../lib/common.sh

readonly C_REBOOT="./C_REBOOT"

main()
{
  # Maybe need disable avc check
  if [ ! -f ${C_REBOOT} ]; then
    prepare_kdump
    # add config kdump.conf in here if need
    restart_kdump
    debug "- boot to 2nd kernel"
    touch "${C_REBOOT}"
    sync
    debug "trigger crash"
	trigger_echo_c
  else
	rm -f "${C_REBOOT}"
  fi

  # add check vmcore test in here if need
  check_vmcore_file
  ready_to_exit
  exit 0
}

main "$@"






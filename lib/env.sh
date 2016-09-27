#!/bin/bash

# This file will cover special test evnironment,
# like special network, special storage env, etc.

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


((INCLUDE_ENV_SH)) && return ||INCLUDE_ENV_SH=1
config_vlan()
{
	echo "config vlan"
}

config_brdige()
{
	echo "config bridge"
}

config_bonding()
{
	echo "config bonding"
}

config_team()
{
	echo "config team"
}

# Special storage env
config_raid()
{
	echo "config raid"
}

config_iscsi()
{
	echo "config iscsi"
}

config_fcoe()
{
	echo "config fcoe"
}

# Configure kvm guest
config_kvm_guest()
{
	echo "config kvm guest"
}

#!/usr/bin/env bash

# This file will test 'crash' command.

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
((INCLUDE_CRASH_SH)) && return ||INCLUDE_CRASH_SH=1

analyse_by_crash()
{
	echo "analyse vmcore by crash commend"
}

analyse_live()
{
	echo "analyse in live system"
}

analyse_by_basic()
{
	echo "analyse vmcore use basic option"
}

analyse_by_gdb()
{
	echo "analyse vmcore by gdb"
}

analyse_by_readelf()
{
	echo "analyse vmcore by readelf"
}

analyse_by_dmesg()
{
	echo "analyse vmcore-dmesg.txt"
}

analyse_by_trace_cmd()
{
	echo "analyse vmcore by trace_cmd"
}

analyse_by_gcore_cmd()
{
	echo "analyse vmcore by gcore_cmd"
}

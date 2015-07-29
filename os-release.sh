#!/bin/sh

##
##    makepkg -- Linux distribution identification script
##
##    This file is part of makepkg, a set of tools and scripts for
##    building and checking Debian/RedHat packages from Makefiles.
##
##    Copyright 2012-2015 GOOBIE
##    See the file AUTHORS for the list of contributors.
##
##    makepkg is free software: you can redistribute it and/or modify
##    it under the terms of the GNU General Public License as published by
##    the Free Software Foundation, either version 3 of the License, or
##    (at your option) any later version.
##
##    makepkg is distributed in the hope that it will be useful,
##    but WITHOUT ANY WARRANTY; without even the implied warranty of
##    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
##    GNU General Public License for more details.
##
##    You should have received a copy of the GNU General Public License
##    along with makepkg.  If not, see <http://www.gnu.org/licenses/>.
##

unset SHORT
unset TYPE
if [ "$1" = '--short' ]; then
    SHORT=yes
elif [ "$1" = '--type' ]; then
    TYPE=yes
elif [ -n "$1" ]; then
    echo "Usage: $0 [--short|--type]"
    echo "\nDisplay a description of the current Linux distribution.\n"
    echo "Available options:"
    echo "  --type  : display the type of distribution (Debian or RedHat)"
    echo "  --short : display the short distribution name (Ubuntu, Debian, RedHat, Centos, Fedora, etc.)"
    exit 1
fi

if [ -f /etc/os-release ]; then
    if [ -n "$TYPE" ]; then
	echo Debian
    else
	. /etc/os-release
	if [ -n "$SHORT" ]; then
	    echo $NAME
	else
	    echo $NAME $VERSION
	fi
    fi
elif [ -f /etc/system-release ]; then
    if [ -n "$TYPE" ]; then
	echo RedHat
    else
	if [ -n "$SHORT" ]; then
	    cut -d' ' -f1 /etc/system-release
	else
	    cat /etc/system-release
	fi
    fi
fi

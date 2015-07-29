#!/bin/bash

##
##    makepkg -- Linux development packages checker (script)
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

BINDIR=$(dirname "$0")
DISTRO=$("$BINDIR/os-release.sh" --type)

if [ "$DISTRO" = 'Debian' ]; then
    PKGTOOL="dpkg -s"
elif [ "$DISTRO" = 'RedHat' ]; then
    PKGTOOL="rpm -q"
else
    echo "Cannot probe OS type, so unable to check installed packages"
    exit 1
fi

echo -n "Checking required packages ($DISTRO)... "
MISSING=""
for pkg in $*; do
    $PKGTOOL $pkg >/dev/null 2>/dev/null || MISSING="$MISSING $pkg"
done

if [ -n "$MISSING" ]; then
    echo -e "\nERROR: missing packages: $MISSING"
    exit 1
fi

echo "OK"
exit 0

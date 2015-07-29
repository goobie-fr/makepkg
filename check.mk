##
##    makepkg -- Linux development packages checker (Makefile rules)
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

ifndef CHECK_DISTRO

MAKEPKG_DIR ?= $(dir $(lastword $(MAKEFILE_LIST)))

CHECK_DISTRO := $(shell $(MAKEPKG_DIR)/os-release.sh --type)
ifeq ($(CHECK_DISTRO),Debian)
CHECK_PACKAGES += $(CHECK_PACKAGES_deb)
else ifeq ($(CHECK_DISTRO),RedHat)
CHECK_PACKAGES += $(CHECK_PACKAGES_rpm)
endif

check_tools:
	@$(MAKEPKG_DIR)/check-installed.sh $(CHECK_PACKAGES)

endif

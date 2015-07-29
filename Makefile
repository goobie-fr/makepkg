##
##    makepkg -- Top-level build rules
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

PKGNAME := makepkg
DEBARCH := all
RPMARCH := noarch
VERSION := $(shell ./gitversion.sh)

SHARE_DIR = $(DESTDIR)/usr/share/$(PKGNAME)
DOC_DIR = $(DESTDIR)/usr/share/doc/$(PKGNAME)

all: deb

install:
	mkdir -p $(SHARE_DIR) $(DOC_DIR)
	install -m 0755 $(wildcard *.sh) $(SHARE_DIR)
	install -m 0644 $(wildcard *.mk) $(SHARE_DIR)
	install -m 0644 README.md AUTHORS $(DOC_DIR)

clean:
	rm -rf $(DESTDIR) *~

include pkg.mk

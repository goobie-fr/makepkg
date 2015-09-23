##
##    makepkg -- Linux distribution packages builder
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

ifdef PKGNAME  # Hide packaging rules if package name not defined

ifeq ($(VERSION),)
VERSION := 0
endif
RPMARCH ?= $(shell arch)
DEBARCH ?= $(shell dpkg-architecture -qDEB_HOST_ARCH)

# 
# Target directories
#
ifneq ($(ARCH),)
OUTDIR ?= out/$(ARCH)
else
OUTDIR ?= out
endif
DESTDIR ?= $(OUTDIR)/root
PKGDIR ?= $(OUTDIR)

#
# Check required tools are installed
#
CHECK_PACKAGES_deb += fakeroot dpkg-dev
CHECK_PACKAGES_rpm += rpm-build

MAKEPKG_DIR ?= $(dir $(lastword $(MAKEFILE_LIST)))
include $(MAKEPKG_DIR)/check.mk

#
# Check required variables are defined
#
check_vars:
ifdef PKGDIR
	mkdir -p $(PKGDIR)
else
	@echo "Variable PKGDIR not defined"; false
endif
ifndef DESTDIR
	@echo "Variable DESTDIR not defined"; false
endif

# 
# Package build rule for RedHat
#
rpm: check_tools check_vars install
	rm -rf $(DESTDIR)/DEBIAN
	mkdir -p $(PKGDIR)/BUILD
	sed -e 's/@NAME@/$(PKGNAME)/' \
	    -e 's/@VERSION@/$(VERSION)/' \
	    -e 's/@RELEASE@/$(BUILDDATE)/' \
	    spec.in > $(PKGDIR)/RPM.spec
	find $(DESTDIR) -type f | sed 's|^$(DESTDIR)||' > $(PKGDIR)/BUILD/RPM.files
	echo "%_topdir $(PWD)/$(PKGDIR)" > $(HOME)/.rpmmacros
	rpmbuild -bb $(PKGDIR)/RPM.spec --buildroot=$(PWD)/$(DESTDIR) --target $(RPMARCH)
	mv -f $(PKGDIR)/RPMS/*/*.rpm $(PKGDIR)

# 
# Package build rule for Debian
#
BUILDDATE := $(shell date +%y%m%d)
deb: check_tools check_vars install
	mkdir -p $(DESTDIR)/DEBIAN
	for file in preinst postinst prerm postrm rules conffiles; do \
		[ -f $$file ] && install -m 755 $$file $(DESTDIR)/DEBIAN/; done; \
	grep -v '^#' control.in | \
	sed -e 's/@NAME@/$(PKGNAME)/' \
	    -e 's/@ARCH@/$(DEBARCH)/' \
	    -e 's/@VERSION@/$(VERSION)-$(BUILDDATE)/' \
	    > $(DESTDIR)/DEBIAN/control
	fakeroot dpkg-deb --build $(DESTDIR) $(PKGDIR)/$(PKGNAME)_$(VERSION)-$(BUILDDATE)_$(DEBARCH).deb

else
rpm deb:
	@echo "Variable PKGNAME not defined"; false
endif

pkgclean:
ifdef PKGDIR
	$(RM) $(PKGDIR)
else
	@true
endif

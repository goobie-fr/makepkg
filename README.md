# makepkg
A set of tools and scripts for building and checking Debian/RedHat packages from Makefiles.

## Overview
makepkg provides some scripts and Makefile rules to support .deb/.rpm packaging.
The basic tasks are:
- Checking all required packages are installed in order for a Makefile to run successfully ;
- Generating a .deb and/or .rpm package from a simple "make install" rule.

A comprehensive example is given in makepkg source tree itself.

## Install makepkg
From source:
```
$ sudo make DESTDIR= install
```

By generating a package:
```
$ make deb
$ sudo dpkg -i out/makepkg_*.deb
```

## Write a Makefile
Typical Makefile pattern:
```Makefile
# Specify the package base name in variable PKGNAME,
# without version id nor architecture suffix.
PKGNAME := <MyPackage>

# Let makepkg guess the package version from the latest GIT tag
VERSION = $(shell /usr/share/makepkg/gitversion.sh)

# Uncomment the 2 follolwing lines if the package is architecture-independent,
# i.e. if it does not contain natively executable code.
# Default value is the architecture of the current machine.
#DEBARCH := all
#RPMARCH := noarch

# List of .deb packages required by the Makefile when run on a Debian-style distro
CHECK_PACKAGES_deb += <Required DEB package list>

# List of .rpm packages required by the Makefile when run on a RedHat-style distro
CHECK_PACKAGES_rpm += <Required RPM package list>

all: check
	<Put your build rules here>

# Include makepkg rules
include /usr/share/makepkg/pkg.mk

# Copy the files to be packaged in the staging directory $(DESTDIR)
# By default, DESTDIR = out/root
install:
	mkdir -p $(DESTDIR)/...
	<Copy files to $(DESTDIR)>
```

## Generate a.deb or .rpm package
### Write package specification file.

control.in for Debian-style packages:
```
Package: @NAME@
Priority: optional
Version: @VERSION@
Architecture: @ARCH@
Maintainer: <Your name>
Section: <Package category, e.g. devel>
Depends: <List of package dependencies (comma-separated items)>
Description: <Package description>
```

spec.in for RedHat-style packages:
```
Name:     @NAME@
Version:  @VERSION@
Release:  @RELEASE@
Summary:  <A short description>
Packager: <Your name>
Requires: <List of package dependencies (space-separated items)>
Group:    <Package category, e.g. Development/Tools>
License:  <Your Lincense, e.g. GPL>
URL:      <Your web site URL>

%description
<Package description>

%files -f RPM.files
%defattr(-,root,root,-)
```

### Generate package
Debian-style package:
```
$ make deb
```
RedHat-style package:
```
$ make rpm
```

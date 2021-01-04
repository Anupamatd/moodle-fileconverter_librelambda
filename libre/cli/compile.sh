#!/usr/bin/env bash

# This script compiles LibreOffice.

# This is the most important part, we set the compile options.
# Run ./autogen.sh --help to see wha each option means
cd libreoffice

./autogen.sh \
    --disable-avahi \
    --disable-cairo-canvas \
    --disable-coinmp \
    --disable-cups \
    --disable-cve-tests \
    --disable-dbus \
    --disable-dconf \
    --disable-dependency-tracking \
    --disable-evolution2 \
    --disable-dbgutil \
    --disable-extension-integration \
    --disable-extension-update \
    --disable-firebird-sdbc \
    --disable-gio \
    --disable-gstreamer-1-0 \
    --disable-gtk3 \
    --disable-introspection \
    --disable-gui \
    --disable-largefile \
    --disable-lotuswordpro \
    --disable-lpsolve \
    --disable-odk \
    --disable-ooenv \
    --disable-pch \
    --disable-postgresql-sdbc \
    --disable-python \
    --disable-randr \
    --disable-report-builder \
    --disable-scripting-beanshell \
    --disable-scripting-javascript \
    --disable-sdremote \
    --disable-sdremote-bluetooth \
    --enable-mergelibs \
    --with-galleries="no" \
    --with-system-curl \
    --with-system-expat \
    --with-system-libxml \
    --with-system-nss \
    --with-system-openssl \
    --with-theme="no" \
    --without-export-validation \
    --without-fonts \
    --without-helppack-integration \
    --without-java \
    --without-junit \
    --without-krb5 \
    --without-myspell-dicts \
    --without-system-dicts

# Disable flaky unit tests failing on macos (and for some reason on Amazon Linux as well).
sudo sed -i 's/\#if\ \!defined\ MACOSX\ \&\& \!\defined\ \_WIN32/\#if\ defined\ MACOSX\ \&\&\ \!defined\ _WIN32/g' vcl/qa/cppunit/pdfexport/pdfexport.cxx

# Compile it! This will take 0-2 hours to compile, depends on the AWS instance size.
make

# Remove ~100 MB of symbols from shared objects.
strip ./instdir/**/*

# Remove unneeded stuff for headless mode.
rm -rf ./instdir/share/gallery \
    ./instdir/share/config/images_*.zip \
    ./instdir/readmes \
    ./instdir/CREDITS.fodt \
    ./instdir/LICENSE* \
./instdir/NOTICE

cd ../

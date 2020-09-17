#!/usr/bin/env bash

# This script rewrites the install_name values for any boost dylibs in the
# `libdir` so that they rely on the @rpath instead of a specific build directory.
#
# After building, the `otool -L` output for the boost dylibs looks something like this:
#
# /opt/puppetlabs/puppet/lib/libboost_locale.dylib:
#     boost/bin.v2/libs/locale/build/gcc-4.8.2/release/threading-multi/libboost_locale.dylib (compatibility version 0.0.0, current version 0.0.0)
#     boost/bin.v2/libs/system/build/gcc-4.8.2/release/threading-multi/libboost_system.dylib (compatibility version 0.0.0, current version 0.0.0)
#     /usr/lib/libiconv.2.dylib (compatibility version 7.0.0, current version 7.0.0)
#     /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 307.4.0)
#     /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1238.0.0)
#
# ...where relative paths to the build directory have been hard-coded. To make these
# libraries useful after relocation, we update them so that they look like this:
#
# /opt/puppetlabs/puppet/lib/libboost_locale.dylib:
#     @rpath/libboost_locale.dylib (compatibility version 0.0.0, current version 0.0.0)
#     @rpath/libboost_system.dylib (compatibility version 0.0.0, current version 0.0.0)
#     /usr/lib/libiconv.2.dylib (compatibility version 7.0.0, current version 7.0.0)
#     /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 307.4.0)
#     /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1238.0.0)

BOOST_DYLIBS=${LIBDIR}/libboost*.dylib

echo "Updating install_name values for boost dylibs..."

for dylib_path in $BOOST_DYLIBS; do
  # Update the id of this dylib from the old relative path to '@rpath/libboost_foo.dylib':
  install_name_tool -id @rpath/$(basename $dylib_path) $dylib_path

  # Update the install_names of each of the boost libraries this library depends on this way, too:
  linked_boost_libs=$(otool -L $dylib_path | tail -n +2 | grep boost | awk '{ print $1 }')
  for old_name in $linked_boost_libs; do
    install_name_tool -change $old_name @rpath/$(basename $old_name) $dylib_path
  done
done

echo "Done."

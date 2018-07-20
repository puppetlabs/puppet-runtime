Boost.Build hard-codes the `install_name` for dynamic libraries on macOS in a
way that makes them unusable in our environment. After a default build, the
`otool -L` output for the boost dylibs will look something like this:

```
 /opt/puppetlabs/puppet/lib/libboost_locale.dylib:
     boost/bin.v2/libs/locale/build/gcc-4.8.2/release/threading-multi/libboost_locale.dylib (compatibility version 0.0.0, current version 0.0.0)
     boost/bin.v2/libs/system/build/gcc-4.8.2/release/threading-multi/libboost_system.dylib (compatibility version 0.0.0, current version 0.0.0)
     /usr/lib/libiconv.2.dylib (compatibility version 7.0.0, current version 7.0.0)
     /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 307.4.0)
     /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1238.0.0)
```

...where the names include hard-coded references to the build directory path.

We could probably find a fix for this involving a patch to boost.build, but
instead, we run a [simple
script](../../resources/files/boost/macos_rpath_install_names.erb) to
retroactively update the `install_name`s for each dylib using
`install_name_tool`. This script sets the install name of each boost library
and the install names of its internal dependencies so that they are based on
`@rpath` instead of the build directory. This means that libraries consuming
the boost dylibs will look for them in their rpaths instead of the original
build directory.

Afterward, the `otool -L` output for the boost dylibs should look something
like this, instead:

```
 /opt/puppetlabs/puppet/lib/libboost_locale.dylib:
     @rpath/libboost_locale.dylib (compatibility version 0.0.0, current version 0.0.0)
     @rpath/libboost_system.dylib (compatibility version 0.0.0, current version 0.0.0)
     /usr/lib/libiconv.2.dylib (compatibility version 7.0.0, current version 7.0.0)
     /usr/lib/libc++.1.dylib (compatibility version 1.0.0, current version 307.4.0)
     /usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1238.0.0)
```


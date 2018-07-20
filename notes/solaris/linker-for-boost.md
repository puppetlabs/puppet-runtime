Boost build changes to work with the Solaris linker
---

The Solaris linker differs from linkers on other Unix variants: the linker needs to specify that a dynamic library has a 'name'. There's more information in the 'Recording a Shared Object Name' section of https://docs.oracle.com/cd/E19253-01/817-1984/chapter4-97194/index.html, but to summarize:

If you don't specify the `-h <libname>` flag to the linker, the linker will use paths instead of filenames in links to other libraries. In boost, this means when boost libs are linked to each other you would see something like `boost/bin.v2/libs/system/build/gcc-4.8.2/release/threading-multi/libboost_system.so.1.67.0` instead of just `libboost_system.so.1.67.0` as the linked library. That meant whenever an actual executable tried to run it would check `$RPATH/boost/bin.v2/libs/system/build/gcc-4.8.2/release/threading-multi/libboost_system.so.1.67.0` and fail because that whole dir structure won't exist after the boost libs are moved to the actual prefix and out of the dir they were built in.

When you specify the `-h libboost_system.so.1.67.0` flag to the solaris linker you add a 'shared object name' to the library, and when things attempt to link against it they will use _only_ the libname, not that whole path.

The [force SONAME patch](../../resources/patches/boost/force-SONAME-option-for-solaris.patch) patches the gcc jamfile in the boost build to force use of the `-h` flag.

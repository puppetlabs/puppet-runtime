# macOS Builds

## Xcode

Xcode contains the necessary tools to build packages on macOS such as `make`, `cc`, etc. Xcode is preinstalled on our macOS images. If it's missing or out of date, then the image will need to be updated.

The following command will show you where xcode is installed:

```
# xcode-select -p
/Library/Developer/CommandLineTools
```

## Build Tools

Xcode ships a `gcc` binary, but it's actually clang(!)

```
# which gcc
/usr/bin/gcc
# gcc --version
Configured with: --prefix=/Library/Developer/CommandLineTools/usr --with-gxx-include-dir=/Library/Developer/CommandLineTools/SDKs/MacOSX12.1.sdk/usr/include/c++/4.2.1
Apple clang version 13.0.0 (clang-1300.0.27.3)
Target: x86_64-apple-darwin21.3.0
Thread model: posix
InstalledDir: /Library/Developer/CommandLineTools/usr/bin
```

## Homebrew

We use homebrew to install build dependencies like `automake`. It's a good idea to become [familiar with these Homebrew terms](https://docs.brew.sh/Manpage#terminology).

### Installation Directory

Homebrew installs itself into `/usr/local` on macOS Intel and [`/opt/homebrew` on macOS ARM](https://docs.brew.sh/FAQ#why-is-the-default-installation-prefix-opthomebrew-on-apple-silicon). To account for these differences you can use the [`brew` method in vanagon](https://github.com/puppetlabs/vanagon/commit/02134c79ce917fe82e6b201b9efd6faf73b1b116).

### Permissions

Homebrew does not allow itself to be run as root:

```
# brew list
Error: Running Homebrew as root is extremely dangerous and no longer supported.
As Homebrew does not drop privileges on installation you would be giving all
build scripts full access to your system
```

So we create a `test` user and execute all `brew` commands as that user. Importantly, brew must be executed from a current working directory that the `test` user has access to, so you'll see things like:

```
# cd /etc/homebrew
# su test -c '/usr/local/bin/brew install cmake'
```

### Symlinks

The `brew install <formula>` command will install a formula ("package definition from upstream sources") into the keg ("installation directory of a given formula version"). For example, if you `brew install cmake`, it will install into a versioned path such as:

```
/usr/local/Cellar/cmake/3.29.2/bin/cmake
```

Homebrew also creates symlinks in `/usr/local/bin`:

```
# ls -la /usr/local/bin/cmake
lrwxr-xr-x  1 test  admin  32 May  6 20:42 /usr/local/bin/cmake -> ../Cellar/cmake/3.29.2/bin/cmake
```

The symlinks are useful when installing a tool that needs to be executed during the build, such as cmake, autoconf, perl, etc.

However, you have to be careful when installing a homebrew formula (or one of its transitive dependencies) is also a vanagon component, such as `openssl`. For example, the `ruby@3.2` formula depends on `openssl@3` (currently 3.3.0). However, the agent's openssl component is currently `3.0.x`. By default, clang will prefer the headers that homebrew symlinked and compile against those. But at runtime, only the libraries that we built will be present.

To avoid conflicts, you should run `brew unlink <formula>` for any formula that is also a vanagon component.

One exception is if the formula is keg-only, which just means homebrew won't create symlinks. For example,  [`readline` is keg-only](https://github.com/Homebrew/homebrew-core/blob/c0218d50084e300cba26da84028acfd4917ce623/Formula/r/readline.rb#L77)

## Troubleshooting

To view library dependencies, use `otool -L` (instead of `ldd`):

```
# otool -L /opt/puppetlabs/puppet/lib/libcurl.dylib
/opt/puppetlabs/puppet/lib/libcurl.dylib:
	/opt/puppetlabs/puppet/lib/libcurl.4.dylib (compatibility version 13.0.0, current version 13.0.0)
	/opt/puppetlabs/puppet/lib/libssl.3.dylib (compatibility version 3.0.0, current version 3.0.0)
	/opt/puppetlabs/puppet/lib/libcrypto.3.dylib (compatibility version 3.0.0, current version 3.0.0)
	/usr/lib/libz.1.dylib (compatibility version 1.0.0, current version 1.2.11)
	/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation (compatibility version 150.0.0, current version 1856.105.0)
	/System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices (compatibility version 1.0.0, current version 1141.1.0)
	/System/Library/Frameworks/SystemConfiguration.framework/Versions/A/SystemConfiguration (compatibility version 1.0.0, current version 1163.60.3)
	/usr/lib/libSystem.B.dylib (compatibility version 1.0.0, current version 1311.0.0)
```

To view undefined symbols (which are expected to be defined in some other library). For example, `libcurl.dylib` expects the `_TLS_client_method` function to be defined in `libssl.dylib`:

```
# nm -m /opt/puppetlabs/puppet/lib/libcurl.dylib | grep TLS_
                 (undefined) external _TLS_client_method (from libssl)
```

To view symbols defined in a library:

```
# nm -gU /opt/puppetlabs/puppet/lib/libcurl.dylib | grep _curl_easy_init
0000000000017fac T _curl_easy_init
```

To trace how the dynamic loader (dyld) resolves library dependencies:

```
# export DYLD_PRINT_LIBRARIES=1
# /usr/local/Cellar/openssl\@3/3.3.0/bin/openssl version
dyld[15123]: <E40CB605-B353-3E76-9988-2BD24334BDC1> /usr/local/Cellar/openssl@3/3.3.0/bin/openssl
dyld[15123]: <EB3C4397-8AA0-3CCD-8235-34BE887EB194> /usr/local/Cellar/openssl@3/3.3.0/lib/libssl.3.dylib
dyld[15123]: <71192998-23D0-3BAD-AAC9-DC90966A8177> /usr/local/Cellar/openssl@3/3.3.0/lib/libcrypto.3.dylib
dyld[15123]: <155C5726-E0E6-3FAF-9CD5-CD8E043487D5> /usr/lib/libSystem.B.dylib
dyld[15123]: <952A7572-D3ED-388C-8190-DD17DDCC6522> /usr/lib/system/libcache.dylib
dyld[15123]: <9E46E39C-0DBB-333A-9597-23FA11E5B96C> /usr/lib/system/libcommonCrypto.dylib
...
```

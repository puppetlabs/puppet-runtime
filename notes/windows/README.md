# Windows Builds

Thare are a number of tools that *can* be used to build software on Windows. Unfortunately many of them are similarly named or have overlapping functionality. This document describes which ones we use and why.

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [mingw-w64](#mingw-w64)
- [msys2](#msys2)
- [Cygwin](#cygwin)
- [Chocolatey](#chocolatey)
- [WiX](#wix)
- [FAQ](#faq)
    - [Q: What's the difference between mingw-w64 and msys2?](#q-whats-the-difference-between-mingw-w64-and-msys2)
    - [Q: What's the difference between cygwin and msys/msys2?](#q-whats-the-difference-between-cygwin-and-msysmsys2)
    - [Q: What's the difference between chocolatey and msys2?](#q-whats-the-difference-between-chocolatey-and-msys2)

<!-- markdown-toc end -->

## mingw-w64

It stands for "Minimalist GNU for Windows". From [mingw-w64.org](https://www.mingw-w64.org/)

> Mingw-w64 is an advancement of the original mingw.org project, created to support the GCC compiler on Windows systems. It has forked it in 2007 in order to provide support for 64 bits and new APIs

We use the `gcc` toolchain from `mingw-w64` to build on Windows.

Note we don't use the [original `mingw` project](https://en.wikipedia.org/wiki/MinGW), only its successor `mingw-w64`.

## msys2

It stands for Minimal System 2. From [msys2.org](https://www.msys2.org/):

> [msys2] is a collection of tools and libraries providing you with an easy-to-use environment for building, installing and running native Windows software.

`msys2` provides a [package repository](https://packages.msys2.org/base) with over 2500 precompiled packages, everything from `bash`, `boost`, `clang`, `curl, etc and it uses `pacman` (originally from ArchLinux) as its package manager.

Note there is also a similarly named toolset `msys`:

> MSYS2 is an independent rewrite of MSYS, based on modern Cygwin and MinGW-w64 with the aim of better interoperability with native Windows software.

We don't use `msys` nor `msys2`, though in theory we could use `msys2` in the future and eliminate our reliance on `cygwin`.

## Cygwin

We currently rely on Cygwin 2.x in CI, because it seemed like a good idea at the time (circa 2011). Windows hosts in CI are configured to use Cygwin's `opensshd` server. When ssh'ing to a Windows host in CI, `opensshd` will launch Cygwin's `bash`.

You can check which version is in use by running:

```shell
$ cygcheck -V
cygcheck (cygwin) 2.4.0
```

Our builds frequently need to modify the `PATH`, such as to include the `bin` directory for `gcc`. It is important to specify a unix style path, such as `export PATH=$PATH:/cygdrive/c/pl-build-tools/bin`. In order to generate the unix style path, we frequently use `cygpath` to map Windows to Unix paths. However, it is very slow, so use it sparingly:

```shell
$ echo $(cygpath -u C:/path)
/cygdrive/c/path
```

For more information about `cygwin` see https://perforce.atlassian.net/wiki/spaces/AGENT/pages/369365050/Cygwin

## Chocolatey

We use Chocolatey as a package manager on Windows to install build tools, such as `gcc` from `mingw-w64`, as opposed to using `msys2` to install [`mingw-w64-gcc`](https://packages.msys2.org/base/mingw-w64-gcc). Our artifactory instance hosts a [nuget feed](https://artifactory.delivery.puppetlabs.net/artifactory/api/nuget/nuget), from which chocolatey installs packages. We intentionally remove the community chocolatey feed so we don't install arbitrary packages from the internet.

## WiX

WiX is a tool for generating Windows Installer packages (MSI) from XML definitions. The XML schema is documented in https://wixtoolset.org/docs/v3/. Wix produces an [MSI package](https://learn.microsoft.com/en-us/windows/win32/msi/installer-database). Each MSI package is a database whose tables describe what changes need to be applied to the system, such as files and services to install, permissions to apply, post install scripts, etc.

See also the [Windows Installer reference](https://learn.microsoft.com/en-us/windows/win32/msi/installer-database-reference) describing the schema for each database table.

## FAQ

### Q: What's the difference between mingw-w64 and msys2?

A: `mingw-w64` only provides a GCC compiler for Windows, whereas `msys2` provides a complete set of development tools that have been compiled for Windows, e.g. `bash`.

### Q: What's the difference between cygwin and msys/msys2?

A: `cygwin` provides an emulation layer (cygwin1.dll) so that POSIX APIs can be called from Windows systems. However, it enforces several "cygwin-isms" on resulting executables, which make it difficult when trying to interoperate with non-cygwin executables, especially when dealing with file paths and permissions. See https://www.msys2.org/wiki/How-does-MSYS2-differ-from-Cygwin/ for more details.

`msys` forked `cygwin`, preserving much of the core functionality, but eliminating the parts about `cygwin` that everyone dislikes.

### Q: What's the difference between chocolatey and msys2?

A: `msys2` and `chocolatey` both provide repositories of prebuilt Windows binaries. `msys2` uses `pacman` as its package manager. Chocolatey implements a package manager relying on NuGet and PowerShell.

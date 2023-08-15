# Cross Compiling

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

  - [Vanagon](#vanagon)
  - [GCC](#gcc)
  - [CFLAGS/LDFLAGS](#cflagsldflags)
  - [pkg-config](#pkg-config)
  - [Ruby](#ruby)
      - [Base Ruby](#base-ruby)
      - [RbConfig](#rbconfig)
      - [Native Gems](#native-gems)
          - [Fake RbConfig](#fake-rbconfig)
          - [pkg-config](#pkg-config-1)
  - [Checking libraries](#checking-libraries)
      - [Architecture](#architecture)

<!-- markdown-toc end -->

We usually native compile the puppet-runtime for each operating system, version and architecture. However, there are times when it is necessary to cross-compile, because we don't have the necessary hardware to native compile. For more information about the distinction between `native` and `cross` compilation, see [GCC's definition of `host`, `build` and `target`](https://gcc.gnu.org/onlinedocs/gccint/Configure-Terms.html).

There are (at least) two downsides to cross-compiling. First, it adds complexity to the build process and care must be taken to ensure the resulting binaries are built for the current `architecture` This is especially true for gems with native extensions, like ffi. Second, it's not possible to test the resulting binaries at build time. For example, if we're building on macOS 12 Intel for macOS 12 ARM, then the `build` host is Intel while the `host` is ARM. During the build, we execute `gcc` on Intel and it produces binaries for ARM, which cannot be executed locally on Intel.

However, sometimes we have to cross compile and this document describes some of the issues you'll likely encounter.

## Vanagon

By default, vanagon will assume native complation, so all cross compiled projects will have a platform definition similar to `configs/platforms/solaris-10-sparc.rb`:

```ruby
platform "solaris-10-sparc" do |plat|
  plat.cross_compiled true
  ...
```

The `Vanagon::Platform.is_cross_compiled?` method can be called within the vanagon project and components to determine if the build is native or cross compiled. For example, when cross compiling we must specify a `base` ruby to use when building ruby:

```ruby
if platform.is_cross_compiled? && platform.is_linux?
    special_flags += " --with-baseruby=#{host_ruby} "
```

## GCC

The runtime relies on `gcc` compiler. When cross-compiling it is sometimes necessary to define/override the `CC` and `PATH` environment variables to ensure the cross-compiler is used instead of the system compiler (in `/usr/bin/gcc`). For example, here we prepend the `pl-build-tools` cross-compiler to our `PATH:`

```ruby
  elsif platform.is_cross_compiled_linux?
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH):#{settings[:bindir]}"
```

Note macOS is the exception, as we use `clang`. My recollection is Night's Watch did that in order to support cross-compiling. We've stopped cross compiling macOS ARM starting with 13, so it may be that `clang` is no longer needed.

## CFLAGS/LDFLAGS

Some runtime components set or overrride `CFLAGS` & `LDFLAGS`. When cross-compiling, it's important that those settings refer to the host we're building for (`host`) and not the host we're building on (`build`). For example, you should expect to see `LDFLAGS=-L/opt/puppetlabs/puppet/lib` and not `LDFLAGS=-L/usr/lib`.

## pkg-config

[`pkg-config`](https://people.freedesktop.org/~dbn/pkg-config-guide.html) is a tool to:

 > provide the necessary details for compiling and linking a program to a library.
 
Some runtime components use `pkg-config` to provide those details. To understand how it works and why, consider that `curl` and `ruby` both depend on `openssl`. It's possible for both `curl` and `ruby` to pass the compiler and linker flags necessary to build against `openssl`, but as the number of components and dependencies increase, it becomes difficult to maintain multiple sources of truth.

`pkg-config` aims to solve that problem, so when building `curl` and `ruby`, their respective `configure` scripts will query `pkg-config` for compiler and linker flags to use for its dependencies, such as `openssl`. In effect, the `configure` script runs this command to determine which arguments to pass to the linker search path `-L`:

```
$ pkg-config --variable libdir openssl
/usr/lib/x86_64-linux-gnu
```

Note that invocation is actually incorrect when cross-compiling, since `pkg-config` returned the default system location (for the `build` host), not the lib directory for the `host` we're targeting. This is why it's important to always specify the `PKG_CONFIG_PATH` environment variable. Doing so returns the expected results:

```
$ PKG_CONFIG_PATH=/opt/puppetlabs/puppet/lib/pkgconfig pkg-config --variable libdir openssl
/opt/puppetlabs/puppet/lib
```

Note `pkg-config` only works if the component's `configure` script supports it. For example, here's what curl says about using `pkg-config`:

https://github.com/curl/curl/blob/curl-7_88_1/docs/INSTALL.md?plain=1#L68-L71

## Ruby

Ruby is the main component within the puppet-runtime project. For some general background information about building ruby, see https://docs.ruby-lang.org/en/master/contributing/building_ruby_md.html

### Base Ruby

In order to build ruby, you'll need a `base` ruby that the build process can use to bootstrap itself.

If you are *native* compiling, then the ruby build process should always build `miniruby` and use that to bootstrap the rest of the build. In order for this to work reliably, you SHOULD always specify `--with-baseruby=no` when configuring the ruby build so that the configure script doesn't attempt to use whatever system ruby happens to be in the `PATH`. For unknown reasons we don't set `--with-baseruby=no` consistently for native compiles, but we should for any new OS.

If you are *cross* compiling, then you *must* specify `--with-baseruby=/path/to/ruby` and the version must meet the minimum ruby version requirement. For example, ruby 3.2 requires `base` ruby 2.7 or above. If possible, it's best to use a `base` ruby that is the same version as the one you're trying to build.

It is also recommended to install a `base` ruby from the OS vendors' repositories. For example, we install `ruby@3` from homebrew when cross compiling macOS 12 ARM. If no other ruby is available, then you may need to build one, as we've done in the past for [pl-ruby](https://github.com/puppetlabs/pl-build-tools-vanagon/blob/main/configs/projects/pl-ruby.rb).

### RbConfig

During the build, ruby will generate an `rbconfig.rb` containing information about the build configuration such as the compiler, operating system and architecture. Since this file is architecture specific, it is written to a path such as:

```
$ /opt/puppetlabs/puppet/bin/gem which rbconfig
/opt/puppetlabs/puppet/lib/ruby/2.7.0/x86_64-linux/rbconfig.rb
```

It is also possible to query ruby programmatically for those values:

```
$ /opt/puppetlabs/puppet/bin/ruby -rrbconfig -e 'puts RbConfig::CONFIG["arch"]'
x86_64-linux
```

When cross-compiling `rbconfig.rb` sometimes ends up with values for the `build` host, e.g. `Intel`, not the `host` that you're targeting, e.g. `ARM`.

### Native Gems

Most gems contain only ruby code, but there are also gems with native extensions, such as [`ffi`](https://github.com/ffi/ffi). Native extensions are implemented in C or Rust and must conform to the native extension API. When the gem is installed, the C source files are compiled into a shared library and made available to the ruby installation, so that they can be called from ruby, such as `require 'ffi'`. See https://guides.rubygems.org/gems-with-extensions/ for more details.

If a gem contains a native extension, then it must specify an [`extensions`](https://guides.rubygems.org/specification-reference/#extensions) entry in its gemspec referring to the gem's `extconf.rb`. For example, here is the [`ffi.gemspec`](https://github.com/ffi/ffi/blob/a480ff6db209713fc73a3dbbb4f1c31a376d6e6a/ffi.gemspec#L33). When `gem install` is executed, ruby will call `Gem::Ext::ExtConfBuilder.build` to make the Makefile needed to compile the extension. To do that `ExtConfBuilder` executes [`ruby -rmkmf extconf.rb`](https://github.com/ruby/ruby/blob/1c7624469880bcb964be09a49e4907873f45b026/lib/mkmf.rb#L4). The module uses information in `rbconfig.rb` such as `CC`, `CFLAGS` generate the Makefile For example, in Ruby 3.2.2 `mkmf` interpolates the [`CC` config option into the Makefile](https://github.com/ruby/ruby/blob/v3_2_2/lib/mkmf.rb#L2036).

When *native* compiling, the `host` and `target` rubies have consistent `rbconfig.rb` files. In other words, the `ruby_version`, `arch`, etc values are the same, so `gem install` just works.

When *cross* compiling, `mkmf` will look up values in the currently running ruby's `rbconfig.rb`, but that won't match the ruby we're building for (`host`). So our build process generates a fake `rbconfig.rb` described next.

#### Fake RbConfig

We include many gems when building the runtime project. In order to cross-compile native extensions for the `host` system, we do two things:

1. We generate a fake `rbconfig.rb` containing build information for the `host`, as opposed to the current `build`. We store that fake `rbconfig.rb` in `/opt/puppetlabs/puppet/share/doc/rbconfig-X.X.X-orig.rb`.
2. We patch `rubygems` in the `baseruby`. For example, when cross-compiling macOS 12 ARM, the `pl-ruby-patch` component executes:

```
$ sed -i 's/Gem::Platform.local.to_s/"arm64-darwin"/' /usr/local/opt/ruby@3.2/lib/ruby/3.2.0/rubygems/basic_specification.rb && \
$ sed -i 's/Gem.extension_api_version/"3.2.0"/' /usr/local/opt/ruby@3.2/lib/ruby/3.2.0/rubygems/basic_specification.rb && \
$ sed -i "s|Gem.ruby.shellsplit|& << '-r/opt/puppetlabs/puppet/share/doc/rbconfig-3.2.2-orig.rb'|" /usr/local/opt/ruby@3.2/lib/ruby/3.2.0/rubygems/ext/builder.rb
```

In places where `rubygems` would execute:

```ruby
Gem.ruby.shellsplit
````

it instead will execute:

```ruby
Gem.ruby.shellsplit << '-r/opt/puppetlabs/puppet/share/doc/rbconfig-#{settings[:ruby_version]}-orig.rb'
```

Later in the runtime build, we execute `gem install --local <name>.gem` for each rubygem component. Rubygems will preload our fake `rbconfig.rb`. This way `mkmf` will use the fake values and build native extensions matching the `host` architecture.

If you're asking yourself, why is this so complicated and fragile. The answer is there were not good ways of cross-compiling native gems many years ago. It may be that there are better wayhs now. For example, the author of nokogiri wrote a series on different ways of packaging native gems (from a gem author's perspective) https://github.com/flavorjones/ruby-c-extensions-explained. Also the current maintainer for RubyInstaller created a way to simplify building gems with native extensions, primarily benefiting Windows and macOS: https://github.com/rake-compiler/rake-compiler-dock

#### pkg-config

Ruby's `mkmf` module supports using `pkg-config` and ideally we would be using that to resolve native extension dependencies. For example, on macOS we rely on the `nokogiri` gem with native extensions in order to speed up processing of plist configuration files. We also build the `libxml2` and `libxslt` native libraries in the runtime. But the `nokogiri` gem doesn't use our prebuilt versions, see [PA-4327](https://perforce.atlassian.net/browse/PA-4327). It's probably a combination of not consistently using `--enable-system-libraries` and not configuring `PKG_CONFIG` and `PKG_CONFIG_PATH` environment variables when installing `nokogiri`.

## Checking libraries

### Architecture

If you're making changes to the runtime and those changes include cross compiled platforms, it's a good idea to double check that all generated executables and shared libraries have the correct architecture. For example, on macOS 12 ARM shared libraries can have either `.dylib` or `.bundle` extension:

```
$ find /opt/puppetlabs/puppet/lib -type f \( -name "*.dylib" -o -name "*.bundle" \) -exec file {} \;
/opt/puppetlabs/puppet/lib/libaugeas.0.dylib: Mach-O 64-bit dynamically linked shared library arm64
/opt/puppetlabs/puppet/lib/libxml2.2.dylib: Mach-O 64-bit dynamically linked shared library arm64
/opt/puppetlabs/puppet/lib/libffi.8.dylib: Mach-O 64-bit dynamically linked shared library arm64
...
```

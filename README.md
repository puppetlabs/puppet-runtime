# puppet-runtime

This repository is archived and Perforce will no longer be updating this repository. For more information, see [this Puppet blog post](https://www.puppet.com/blog/open-source-puppet-updates-2025).

The puppet-runtime exists to build vendored components for
[Puppet](https://github.com/puppetlabs) projects and distribute them as a
tarball for reuse. Runtime projects are built with
[vanagon](https://github.com/puppetlabs/vanagon), a packaging utility.

Available components include curl, openssl, ruby, and more - see the
[configs/components directory](configs/components) for a full list. Individual
projects in the [configs/projects directory](configs/projects) include subsets
of these components. These projects may be built for platforms listed in the
[configs/platforms directory](configs/platforms).

## Build instructions

To build a puppet-runtime project:

- Ruby and [bundler](http://bundler.io/) must be installed
- You must have root ssh access to a VM to build on

First, install the gem dependencies:

```
$ bundle install
```

Next, if you are building on infrastructure outside of Puppet, you will need to
modify some package dependency names in the [configs directory](configs). Any
references to pl-gcc, pl-cmake, pl-yaml-cpp, etc. in these files will need to
be changed to refer to equivalent installable packages on your target platform.
In many cases, you can drop the `pl-` prefix and ensure that `CXX` or `CC`
environment variables are what they should be.

Next, determine which of the [runtime projects](configs/projects) in this
repository you need to build. This will depend on the target repository that
consumes your finished runtime. In some cases, there is only one runtime
project available (`runtime-pdk`, for example, is the only runtime for the
PDK). In other cases, the runtime project to build may depend on the branch of
the target repository that consumes the runtime. For example, puppet-agent is
developed on multiple git branches; You should select the runtime project that
matches the target branch (for instance, you would build `agent-runtime-5.3.x`
for use with puppet-agent's 5.3.x branch).  See the
[configs/projects](configs/projects) directory for a full list of options.

You can build the project using vanagon like this:

```
$ bundle exec build <project-name> <platform> <target-vm>
```

Where:
- `project-name` is the name of the runtime project to build (from
  [configs/projects](configs/projects))
- `platform` is the name of a platform supported by vanagon and configured in
  the [configs/platforms](configs/platforms) directory
- `target-vm` is the hostname of the VM you will build on. You must have root
  ssh access configured for this host, and it must match the target platform.

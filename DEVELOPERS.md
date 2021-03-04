## Troubleshooting Vanagon Builds on Windows

When building projects against Windows targets, it can be a little tricky to debug them and can take
a long time to re-run and verify that a fix worked. These are a few helpful workflows for testing
changes more quickly (and apologies in advance for the word-vomit).

### Debugging workflow

Often when debugging failed builds you'll want to use the following workflow:
1. Run the build and print the output to a file:
  ```
  bundle exec build <platform> [hostname] > vanagon-output
  ```
1. Either use a remote desktop client to RDP into the host, or use SSH to start a cygwin shell
1. Debug failures. This will depend on what kind of errors you're getting, but most likely will
   involve 

### Rebuilding gem dependencies directly on the target

Once you've built against a target once, you can edit any environment variables or files needed and
manually rebuild just the failed dependency on the target. This provides a much faster workflow for
verifying fixes than rebuilding the entire project.

1. Make sure you've already built the project against the target at least once
1. Either in terminal scroll back or in the vanagon-output file, find where the `GEM_HOME`, `PATH`,
   and any other environment variables are exported when building the gem that's failing.
1. Copy those declarations and in a cygwin shell (either via SSH, or by opening a new cygwin
   shell in your RDP session) paste them.
1. `cd` to the path where the failing gem dependency is, most likely
   `/cygdrive/c/ProgramFiles64Folder/Puppet Labs/Bolt/lib/ruby/gems/2.7.0/gems/<mygem>` or something
   along those lines.
1. Run `make`
1. Profit.

### Using `inspect` to see environment changes

If your changes primarily affect the environment variables Vanagon sets, you can use `bundle exec
inspect <platform>` to see changes to those variables and ensure everything is being set correctly.
This can be much quicker than doing a whole new build.

### Rebuilding against the same target after debugging

To rerun Vanagon against the same machine (which is already allocated and provisioned), you'll want
to remove the `C:\ProgramFiles64Folder` directory from the target machine then rerun `bundle exec
build`. This directory is created by Vanagon during the build process, and is where gems are
compiled.


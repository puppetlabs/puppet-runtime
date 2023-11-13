# 2. Enforce openssl header separation in pdk-runtime

Date: 2023-11-13

## Status

Accepted

## Context

Due to the need for two OpenSSL versions in pdk-runtime, a critical issue arose during acceptance testing, manifesting as a version mismatch between OpenSSL libraries and headers. The problem originated from a homebrew update on June 20th, which switched the berkely-db component to use openssl@3.0 instead of openssl@1.1.  See <https://github.com/Homebrew/homebrew-core/pull/134276/files>.  This led to complications during the build process, where the first installed OpenSSL version had its headers overwritten when the second version was installed, causing a conflict. This situation is unique to pdk-runtime, as it builds Ruby 2.7.8 with openssl1.1.1 and Ruby 3.0 with openssl3.0, making the homebrew update a significant concern for the overall system stability.

The acceptance test suite error is as follows:

```bash
$PATH" /bin/sh -c '/opt/puppetlabs/pdk/private/git/bin/git clone https://github.com/puppetlabs/puppetlabs-motd /var/root/puppetlabs-motd'
03:10:13        Last 10 lines of output were:
03:10:13        	Cloning into '/var/root/puppetlabs-motd'...
03:10:13        	dyld: lazy symbol binding failed: Symbol not found: _X509_STORE_load_file
03:10:13        	  Referenced from: /opt/puppetlabs/pdk/lib/libcurl.4.dylib
03:10:13        	  Expected in: flat namespace  	
```

## Decision

Therefore, we (Josh Cooper and David Swan) decided to address the issue by taking the following actions:

* We inverted the order of installation for the two OpenSSL versions (1.1.1 and 3.0), making 3.0 the primary version.  Now the openssl@3.0 is installed first as the primary version for the PDK and openssl@1.1.1 is installed later as an external component which can be activited when needed, for example for the ruby 2.7.8 component.
* We implemented measures to safeguard the OpenSSL 3.0 headers, ensuring they are retained and not overwritten by the 1.1.1 headers. Consequently, we are now installing OpenSSL 3.0 as the primary version and utilizing its headers.

## Consequences

In the underlying implementation we introduced two additional components: "pre-additional-rubies" and "post-additional-rubies.".  See the PR <https://github.com/puppetlabs/puppet-runtime/pull/758/files> for more details:

* The pre-component is designed to relocate the ``settings[:prefix]/include/openssl`` directory, preventing it from being overwritten during the build of OpenSSL 1.1.1.
* The post-component is responsible for removing the modified directory and restoring the original version. This ensures that the headers remain in a consistent state.

The rationale behind this approach is to maintain header consistency. Unlike the libcrypto and libssl libraries, which inherently include version numbers in their names, the headers lack this distinction, making it necessary to implement these pre and post components for effective management.

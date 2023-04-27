# This file is used to define the components that make up the PDK runtime package.

matchdata = platform.settings[:ruby_version].match /(\d+)\.\d+\.\d+/
ruby_major_version = matchdata[1].to_i

if ruby_major_version >= 3

  openssl3_platform = [
    platform.is_el?,
    platform.is_fedora?,
    platform.is_sles?,
    platform.is_deb?,
    platform.is_macos?,
    platform.is_windows?
  ].any?

  openssl_version = proj.openssl_version
  openssl_version = '3.0' if openssl3_platform

  # Ruby 3.2 does not package these two libraries so we need to add them as a component
  proj.component 'libffi'
  proj.component 'libyaml'
  proj.component "openssl-#{openssl_version}"
end

# Always build the default openssl version
proj.component "openssl-#{proj.openssl_version}"

# Common deps
proj.component 'curl'

# Git and deps
proj.component 'git'

# Ruby and deps
proj.component 'runtime-pdk'
proj.component 'puppet-ca-bundle'

proj.component 'readline' if platform.is_macos?
proj.component 'augeas' unless platform.is_windows?
proj.component 'libxml2' unless platform.is_windows?
proj.component 'libxslt' unless platform.is_windows?

proj.component "ruby-#{proj.ruby_version}"
proj.component 'ruby-augeas' unless platform.is_windows?
proj.component 'ruby-selinux' if platform.is_el? || platform.is_fedora?
proj.component 'ruby-stomp'

# Additional Rubies
if proj.respond_to?(:additional_rubies)
  proj.additional_rubies.each_key do |rubyver|
    proj.component "ruby-#{rubyver}"

    ruby_minor = rubyver.split('.')[0, 2].join('.')

    proj.component "ruby-#{ruby_minor}-augeas" unless platform.is_windows?
    proj.component "ruby-#{ruby_minor}-selinux" if platform.is_el? || platform.is_fedora?
    proj.component "ruby-#{ruby_minor}-stomp"
  end
end

# PDK Rubygems
proj.component 'rubygem-ffi'
proj.component 'rubygem-locale'
proj.component 'rubygem-text'
proj.component 'rubygem-gettext'
proj.component 'rubygem-fast_gettext'
proj.component 'rubygem-gettext-setup'
proj.component 'rubygem-minitar'

# Bundler
proj.component 'rubygem-bundler'

# Cri and deps
proj.component 'rubygem-cri'

# Childprocess and deps
proj.component 'rubygem-childprocess'
proj.component 'rubygem-hitimes'

## tty-reader and deps
proj.component 'rubygem-tty-screen'
proj.component 'rubygem-tty-cursor'
proj.component 'rubygem-wisper'
proj.component 'rubygem-tty-reader'

## pastel and deps
proj.component 'rubygem-tty-color'
proj.component 'rubygem-pastel'

## root tty gems
proj.component 'rubygem-tty-prompt'
proj.component 'rubygem-tty-spinner'
proj.component 'rubygem-tty-which'

# json-schema and deps
proj.component 'rubygem-public_suffix'
proj.component 'rubygem-addressable'
proj.component 'rubygem-json-schema'

# Analytics deps
proj.component 'rubygem-concurrent-ruby'
proj.component 'rubygem-thor'
proj.component 'rubygem-hocon'
proj.component 'rubygem-facter'
proj.component 'rubygem-httpclient'

# Other deps
proj.component 'rubygem-deep_merge'
proj.component 'rubygem-json_pure'
proj.component 'rubygem-diff-lcs'
proj.component 'rubygem-pathspec'

proj.component 'ansicon' if platform.is_windows?

# This file is used to define the components that make up the PDK runtime package.

if proj.ruby_major_version >= 3
  # Ruby 3.2 does not package these two libraries so we need to add them
  proj.component 'libffi'
  proj.component 'libyaml'
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

# After installing ruby, we need to copy libssp to the ruby bindir on windows
if platform.is_windows?
  ruby_component = @project.get_component "ruby-#{proj.ruby_version}"
  ruby_component.install.push "cp '#{settings[:bindir]}/libssp-0.dll' '#{settings[:ruby_bindir]}/libssp-0.dll'"
end

proj.component 'ruby-augeas' unless platform.is_windows?
proj.component 'ruby-selinux' if platform.is_el? || platform.is_fedora?
proj.component 'ruby-stomp'

# Additional Rubies
if proj.respond_to?(:additional_rubies)
  proj.additional_rubies.each_key do |rubyver|
    raise "Not sure which openssl version to use for ruby #{rubyver}" unless rubyver.start_with?("2.7")

    # old ruby versions don't support openssl 3
    proj.component "openssl-1.1.1"
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

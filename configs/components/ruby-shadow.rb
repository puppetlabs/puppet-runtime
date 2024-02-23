component "ruby-shadow" do |pkg, settings, platform|
  pkg.url "https://github.com/apalmblad/ruby-shadow"
  pkg.ref "refs/tags/2.5.0"

  pkg.build_requires "ruby-#{settings[:ruby_version]}"
  if !platform.is_cross_compiled? && platform.architecture == 'sparc'
    pkg.environment "PATH", "$(PATH):/opt/pl-build-tools/bin:/usr/ccs/bin:/usr/sfw/bin"
  elsif platform.name == 'sles-11-x86_64'
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH)"
  else
    pkg.environment "PATH", "$(PATH):/usr/ccs/bin:/usr/sfw/bin"
  end

  pkg.environment "CONFIGURE_ARGS", '--vendor'

  if platform.is_solaris?
    if platform.is_cross_compiled?
      pkg.environment "RUBY", settings[:host_ruby]
    end

    if !platform.is_cross_compiled? && platform.architecture == 'sparc'
      ruby = File.join(settings[:ruby_bindir], 'ruby')
    else
      # This should really only be done when cross compiling but
      # to avoid breaking solaris x86_64 in 7.x continue preloading
      # our hook.
      ruby = "#{settings[:host_ruby]} -r#{settings[:datadir]}/doc/rbconfig-#{settings[:ruby_version]}-orig.rb"
    end
  elsif platform.is_cross_compiled?
    pkg.environment "RUBY", settings[:host_ruby]
    ruby = "#{settings[:host_ruby]} -r#{settings[:datadir]}/doc/rbconfig-#{settings[:ruby_version]}-orig.rb"
  else
    ruby = File.join(settings[:ruby_bindir], 'ruby')
  end

  matchdata = platform.settings[:ruby_version].match(/(\d+)\.(\d+)\.\d+/)
  ruby_major_version = matchdata[1].to_i
  if ruby_major_version >= 3
    base = "resources/patches/ruby_32"
    # https://github.com/apalmblad/ruby-shadow/issues/26
    # if ruby-shadow gets a 3 release this should be removed
    pkg.apply_patch "#{base}/ruby-shadow-taint.patch", strip: "1"
    pkg.apply_patch "#{base}/ruby-shadow-rbconfig.patch", strip: "1"
  end

  pkg.build do
    [
      "#{ruby} extconf.rb",
      "#{platform[:make]} -e -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"
    ]
  end

  pkg.install do
    ["#{platform[:make]} -e -j$(shell expr $(shell #{platform[:num_cores]}) + 1) DESTDIR=/ install"]
  end
end

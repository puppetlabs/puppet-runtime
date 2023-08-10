# This component patches the pl-ruby package on cross compiled
# platforms. Ruby gem components should require this.
#
# We have to do this when installing gems with native extensions in
# order to trick rubygems into thinking we have a different ruby
# version and target architecture
#
# This component should also be present in the puppet-agent project
component "pl-ruby-patch" do |pkg, settings, platform|
  if platform.is_cross_compiled?
    if platform.is_macos?
      pkg.build_requires 'gnu-sed'
      pkg.environment "PATH", "/usr/local/opt/gnu-sed/libexec/gnubin:$(PATH)"
    end

    ruby_api_version = settings[:ruby_version].gsub(/\.\d*$/, '.0')
    ruby_version_y = settings[:ruby_version].gsub(/(\d+)\.(\d+)\.(\d+)/, '\1.\2')

    base_ruby = case platform.name
                when /solaris-10/
                  "/opt/csw/lib/ruby/2.0.0"
                when /osx/
                  "/usr/local/opt/ruby@#{ruby_version_y}/lib/ruby/#{ruby_api_version}"
                else
                  "/opt/pl-build-tools/lib/ruby/2.1.0"
                end

    # The `target_triple` determines which directory native extensions are stored in the
    # compiled ruby and must match ruby's naming convention.
    #
    # solaris 10 uses ruby 2.0 which doesn't install native extensions based on architecture
    unless platform.name =~ /solaris-10/
      # weird architecture naming conventions...
      target_triple = if platform.architecture =~ /ppc64el|ppc64le/
                        "powerpc64le-linux"
                      elsif platform.name == 'solaris-11-sparc'
                        "sparc-solaris-2.11"
                      elsif platform.is_macos?
                        if ruby_version_y.start_with?('2')
                          "aarch64-darwin"
                        else
                          "arm64-darwin"
                        end
                      else
                        "#{platform.architecture}-linux"
                      end

      pkg.build do
        [
          %(#{platform[:sed]} -i 's/Gem::Platform.local.to_s/"#{target_triple}"/' #{base_ruby}/rubygems/basic_specification.rb),
          %(#{platform[:sed]} -i 's/Gem.extension_api_version/"#{ruby_api_version}"/' #{base_ruby}/rubygems/basic_specification.rb)
        ]
      end
    end

    # make rubygems use our target rbconfig when installing gems
    case File.basename(base_ruby)
    when '2.0.0', '2.1.0'
      sed_command = %(s|Gem.ruby|&, '-r/opt/puppetlabs/puppet/share/doc/rbconfig-#{settings[:ruby_version]}-orig.rb'|)
    else
      sed_command = %(s|Gem.ruby.shellsplit|& << '-r/opt/puppetlabs/puppet/share/doc/rbconfig-#{settings[:ruby_version]}-orig.rb'|)
    end

    # rubygems switched which file has the command we need to patch starting in rubygems 3.4.10, which we install in our formula
    # for ruby in homebrew-puppet
    if Gem::Version.new(settings[:ruby_version]) >= Gem::Version.new('3.2.2') || platform.is_macos? && ruby_version_y.start_with?('2')
      filename = 'builder.rb'
    else
      filename = 'ext_conf_builder.rb'
    end

    pkg.build do
      [
        %(#{platform[:sed]} -i "#{sed_command}" #{base_ruby}/rubygems/ext/#{filename})
      ]
    end
  end
end

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

    ruby_version_y = settings[:ruby_version].gsub(/(\d+)\.(\d+)\.(\d+)/, '\1.\2')

    pkg.add_source("file://resources/files/ruby/patch-hostruby.rb")

    # The `target_triple` determines which directory native extensions are stored in the
    # compiled ruby and must match ruby's naming convention.
    # weird architecture naming conventions...
    target_triple = if platform.architecture =~ /ppc64el|ppc64le/
                      "powerpc64le-linux"
                    elsif platform.name == 'solaris-11-sparc'
                      "sparc-solaris-2.11"
                    elsif platform.name =~ /solaris-10/
                      "sparc-solaris"
                    elsif platform.is_macos?
                      if ruby_version_y.start_with?('2')
                        "aarch64-darwin"
                      else
                        "arm64-darwin"
                      end
                    else
                      "#{platform.architecture}-linux"
                    end

    pkg.install do
      [
        "#{settings[:host_ruby]} patch-hostruby.rb #{settings[:ruby_version]} #{target_triple}"
      ]
    end
  end
end

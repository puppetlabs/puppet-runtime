component 'rubygem-nokogiri' do |pkg, _settings, _platform|
  pkg.version '1.14.2'
  pkg.sha256sum 'c765a74aac6cf430a710bb0b6038b8ee11f177393cd6ae8dadc7a44a6e2658b6'
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.build_requires 'rubygem-mini_portile2'

  gem_home = settings[:gem_home]
  pkg.environment "GEM_HOME", gem_home

  # When cross compiling nokogiri native extensions on macOS 11/12 ARM, there is a 94M tmp
  # directory that's not needed
  if platform.is_macos? && platform.architecture == 'arm64'
    install do
      "rm -r #{gem_home}/gems/nokogiri-#{pkg.get_version}/ext/nokogiri/tmp"
    end
  end
end

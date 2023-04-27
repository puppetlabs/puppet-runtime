component "rubygem-bundler" do |pkg, settings, _platform|
  pkg.version '2.3.26'
  pkg.sha256sum '1ee53cdf61e728ad82c6dbff06cfcd8551d5422e88e86203f0e2dbe9ae999e09'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.install do
    install_commands = []
    install_commands << "#{settings[:gem_install]} bundler-#{pkg.get_version}.gem"

    settings[:additional_rubies].each do |_rubyver, local_settings|
      install_commands << "#{local_settings[:gem_install]} bundler-#{pkg.get_version}.gem"
    end

    install_commands
  end
end

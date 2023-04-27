component "rubygem-tty-color" do |pkg, settings, platform|
  pkg.version "0.6.0"
  pkg.sha256sum '6f9c37ca3a4e2367fb2e6d09722762647d6f455c111f05b59f35730eeb24332a'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

component 'rubygem-mini_portile2' do |pkg, _settings, _platform|
  pkg.version '2.6.1'
  pkg.sha256sum '385fd7a2f3cda0ea5a0cb85551a936da941d7580fc9037a75dea820843aa7dd3'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end

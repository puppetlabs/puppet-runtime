component 'rubygem-hiera-eyaml' do |pkg, settings, platform|
  pkg.version '3.4.0'
  pkg.sha256sum 'cdacb683dc5efefcae9bc668ab881f17ce5597cac1c0493aee7c4387c7c8ff54'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.build_requires 'rubygem-optimist'
  pkg.build_requires 'rubygem-highline'

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end

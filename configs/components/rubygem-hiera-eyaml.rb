component 'rubygem-hiera-eyaml' do |pkg, settings, platform|
  pkg.version '3.1.1'
  pkg.md5sum 'a9f8669033ccb0220f3c3a6cbed9d7e6'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.build_requires 'rubygem-optimist'
  pkg.build_requires 'rubygem-highline'

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end

component 'rubygem-hiera-eyaml' do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version '3.0.0'
  pkg.md5sum '5a05c893e223d56aa73d206f420357e0'
  pkg.url "https://rubygems.org/downloads/hiera-eyaml-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/hiera-eyaml-#{pkg.get_version}.gem"
  pkg.build_requires 'rubygem-optimist'
  pkg.build_requires 'rubygem-highline'
  pkg.build_requires 'rubygem-trollop'

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver:
  pkg.environment 'GEM_HOME', settings[:puppet_gem_vendor_dir]

  pkg.install do
    ["#{settings[:gem_install]} hiera-eyaml-#{pkg.get_version}.gem"]
  end
end

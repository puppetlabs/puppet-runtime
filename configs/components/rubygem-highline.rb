component 'rubygem-highline' do |pkg, settings, _platform|
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.version '1.6.21'
  pkg.md5sum 'fc79952fb9d12957d828da76b94e4ecb'
  pkg.url "https://rubygems.org/downloads/highline-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/highline-#{pkg.get_version}.gem"

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver:
  pkg.environment 'GEM_HOME', settings[:puppet_gem_vendor_dir]

  pkg.install do
    ["#{settings[:gem_install]} highline-#{pkg.get_version}.gem"]
  end
end

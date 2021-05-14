component 'rubygem-highline' do |pkg, settings, _platform|
  pkg.version '2.0.3'
  pkg.md5sum 'be63a46ed7eabcae9a4cf53032dba5bc'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end

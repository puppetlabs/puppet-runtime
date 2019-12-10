component 'rubygem-CFPropertyList' do |pkg, settings, platform|
  pkg.version '2.3.6'
  pkg.md5sum 'ae4086185992f293ffab1641b83286a5'

  instance_eval File.read('configs/components/_base-rubygem.rb')
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end

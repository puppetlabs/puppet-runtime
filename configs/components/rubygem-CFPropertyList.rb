component 'rubygem-CFPropertyList' do |pkg, settings, platform|
  if settings[:ruby_version].to_f >= 3.2
    pkg.version '3.0.6'
    pkg.md5sum 'a10c1a40d093160f7264c0985b89881d'
  else
    pkg.version '2.3.6'
    pkg.md5sum 'ae4086185992f293ffab1641b83286a5'
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end

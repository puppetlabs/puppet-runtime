component 'rubygem-CFPropertyList' do |pkg, settings, platform|
  if settings[:ruby_version].to_f >= 3.2
    pkg.version '3.0.7'
    pkg.md5sum 'ed89ce5e7074a6f8e8b8e744eaf014d0'
  else
    pkg.version '2.3.6'
    pkg.md5sum 'ae4086185992f293ffab1641b83286a5'
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
  pkg.environment "GEM_HOME", settings[:gem_home]
end

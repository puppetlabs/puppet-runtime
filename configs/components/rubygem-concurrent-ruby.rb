component 'rubygem-concurrent-ruby' do |pkg, settings, platform|
  pkg.version '1.1.5'
  pkg.md5sum '4409c2d6925d8448cb34a947eacaa29b'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end

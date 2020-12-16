component 'rubygem-yard' do |pkg, settings, platform|
  pkg.version '0.9.26'
  pkg.md5sum '0eff29921e52a7a422eee1574ede3d1d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end


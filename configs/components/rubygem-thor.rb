component 'rubygem-thor' do |pkg, settings, platform|
  pkg.version '1.2.1'
  pkg.md5sum 'e80a4c4a50ac0af2625e238e683fe595'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.5.1'
  pkg.md5sum '93b75d1acf4eba4ab46cde553f3df763'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

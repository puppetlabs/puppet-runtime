component 'rubygem-x25519' do |pkg, settings, platform|
  pkg.version '1.0.8'
  pkg.md5sum '6d6fd1c422a6d1e370ea6aa2ee356982'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

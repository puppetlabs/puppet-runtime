component 'rubygem-thor' do |pkg, settings, platform|
  pkg.version '0.20.3'
  pkg.md5sum '0370f18c27c9fb0983d53e4c69c4eb77'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

component 'rubygem-concurrent-ruby' do |pkg, settings, platform|
  pkg.version '1.1.8'
  pkg.md5sum '68c226f3ee1bf39313dd4ebc0cf52d43'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

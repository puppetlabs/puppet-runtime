component 'rubygem-concurrent-ruby' do |pkg, settings, platform|
  pkg.version '1.1.10'
  pkg.md5sum '4588a61d5af26e9ee12e9b8babc1b755'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

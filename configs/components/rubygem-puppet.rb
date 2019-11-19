component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version '6.11.0'
  pkg.md5sum '82b56da6c938b9bd05c3bf1bf4e00614'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.0.43'
  pkg.md5sum '22f8388c8e19bb3da0811df5333997a9'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

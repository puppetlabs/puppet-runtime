component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.8.0'
  pkg.md5sum 'e18d4a234f3d92d4484c0cda8808f473'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

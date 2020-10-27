component 'rubygem-msgpack' do |pkg, settings, platform|
  pkg.version '1.4.2'
  
  if platform.is_windows?
    pkg.md5sum '8f5f47873696caf069f2076a2e0722d5'
  else
    pkg.md5sum 'f58a6aace36cd82e9a39ffeeef925afc'
  end

  instance_eval File.read('configs/components/_base-rubygem-compiled.rb')
end

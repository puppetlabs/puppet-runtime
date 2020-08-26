component 'rubygem-puppet' do |pkg, settings, platform|
  pkg.version "6.18.0"
  pkg.md5sum 'bb3455dc67f65785192e0765527177e8'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

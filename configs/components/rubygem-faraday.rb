component 'rubygem-faraday' do |pkg, settings, platform|
  pkg.version '0.17.4'
  pkg.md5sum '4dc35e83a4667e91e9e612fdfd13fe6d'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

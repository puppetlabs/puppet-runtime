component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.2.10'
  pkg.md5sum 'f1b61248f07201dfa5e7f744a9406411'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

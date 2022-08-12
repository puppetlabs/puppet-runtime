component 'rubygem-concurrent-ruby' do |pkg, settings, platform|
  pkg.version '1.1.9'
  pkg.md5sum '417a23cac840f6ea8bdd0841429c3c19'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

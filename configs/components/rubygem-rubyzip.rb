component 'rubygem-rubyzip' do |pkg, settings, platform|
  pkg.version '2.2.0'
  pkg.md5sum '291c5f31a564aab24180473c34482b45'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

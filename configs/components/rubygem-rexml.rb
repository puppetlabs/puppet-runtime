component 'rubygem-rexml' do |pkg, settings, platform|
  pkg.version '3.2.3'
  pkg.md5sum '6d3c7e28ac9a422c3e325b0d5baa6487'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

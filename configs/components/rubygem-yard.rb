component 'rubygem-yard' do |pkg, settings, platform|
  pkg.version '0.9.20'
  pkg.md5sum 'cff24461a59d5ac123d65c332d3ba271'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end


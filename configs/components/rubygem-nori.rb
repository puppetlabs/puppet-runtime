component 'rubygem-nori' do |pkg, settings, platform|
  if settings[:ruby_version].to_f >= 3.2
    pkg.version '2.7.1'
    pkg.md5sum '83952a081b5e86d5aa62943ca9ccf312'
  else
    pkg.version '2.6.0'
    pkg.md5sum 'dc9c83026c10a3eb7093b9c8208c84f7'
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

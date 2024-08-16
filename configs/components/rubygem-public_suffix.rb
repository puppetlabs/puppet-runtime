component 'rubygem-public_suffix' do |pkg, settings, platform|
  if settings[:ruby_version].to_f >= 3.2
    pkg.version '6.0.1'
    pkg.md5sum '12ec93094a3467364c8c6ee5a6e8325a'
  else
    pkg.version '5.1.1'
    pkg.md5sum '0895274ce1ffdadffcd979ced832b851'
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

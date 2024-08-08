component 'rubygem-public_suffix' do |pkg, _settings, _platform|
  version = settings[:rubygem_public_suffix_version] || '5.1.1'
  pkg.version version

  case version
  when '5.1.1'
    pkg.md5sum '0895274ce1ffdadffcd979ced832b851'
  when '6.0.1'
    pkg.md5sum '12ec93094a3467364c8c6ee5a6e8325a'
  else
    raise "rubygem-public_suffix #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

component 'rubygem-minitar' do |pkg, settings, platform|
  version = settings[:rubygem_minitar_version] || '0.9'
  pkg.version version

  case version
  when '1.0.1'
    pkg.sha256sum 'ba258663f25a3e89ca55bfa2680ce35866d5d2d2998c14d2d2342650f5499705'
  when '0.9'
    pkg.md5sum '4ab2c278183c9a83f3ad97066c381d84'
  else
    raise "rubygem-minitar version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

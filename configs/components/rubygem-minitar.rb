component 'rubygem-minitar' do |pkg, settings, platform|
  version = settings[:rubygem_minitar_version] || '0.9'

  pkg.version version

  case version
  when '0.6.1'
    pkg.md5sum 'ce4ee63a94e80fb4e3e66b54b995beaa'
  when '0.9'
    pkg.md5sum '4ab2c278183c9a83f3ad97066c381d84'
  else
    raise "rubygem-minitar version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

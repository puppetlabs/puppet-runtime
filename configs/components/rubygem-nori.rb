component 'rubygem-nori' do |pkg, settings, platform|
  version = settings[:rubygem_nori_version] || '2.6.0'
  pkg.version version

  case version
  when '2.6.0'
    pkg.md5sum 'dc9c83026c10a3eb7093b9c8208c84f7'
  when '2.7.1'
    pkg.md5sum '83952a081b5e86d5aa62943ca9ccf312'
  else
    raise "rubygem-nori #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

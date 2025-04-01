component 'rubygem-concurrent-ruby' do |pkg, settings, platform|
  # Projects may define a :rubygem_concurrent_ruby_version setting
  version = settings[:rubygem_concurrent_ruby_version] || '1.3.5'
  pkg.version version

  case version
  when '1.3.5'
    pkg.sha256sum '813b3e37aca6df2a21a3b9f1d497f8cbab24a2b94cab325bffe65ee0f6cbebc6'
  else
    raise "rubygem-concurrent-ruby #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

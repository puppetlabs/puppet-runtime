component 'rubygem-concurrent-ruby' do |pkg, settings, platform|
  # Projects may define a :rubygem_concurrent_ruby_version setting
  version = settings[:rubygem_concurrent_ruby_version] || '1.2.3'
  pkg.version version

  case version
  when '1.2.3'
    pkg.sha256sum '82fdd3f8a0816e28d513e637bb2b90a45d7b982bdf4f3a0511722d2e495801e2'
  else
    raise "rubygem-concurrent-ruby #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

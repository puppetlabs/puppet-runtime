component 'rubygem-concurrent-ruby' do |pkg, settings, platform|
  # Projects may define a :rubygem_concurrent_ruby_version setting
  version = settings[:rubygem_concurrent_ruby_version] || '1.2.3'
  pkg.version version

  case version
  when '1.2.3'
    pkg.sha256sum '82fdd3f8a0816e28d513e637bb2b90a45d7b982bdf4f3a0511722d2e495801e2'
  when '1.3.3'
    pkg.sha256sum '4f9cd28965c4dcf83ffd3ea7304f9323277be8525819cb18a3b61edcb56a7c6a'
  else
    raise "rubygem-concurrent-ruby #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

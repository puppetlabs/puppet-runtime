component 'rubygem-concurrent-ruby' do |pkg, settings, platform|
  # Projects may define a :rubygem_concurrent_ruby_version setting
  version = settings[:rubygem_concurrent_ruby_version] || '1.2.2'
  pkg.version version

  case version
  when '1.2.2'
    pkg.sha256sum '3879119b8b75e3b62616acc256c64a134d0b0a7a9a3fcba5a233025bcde22c4f'
  else
    raise "rubygem-concurrent-ruby #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

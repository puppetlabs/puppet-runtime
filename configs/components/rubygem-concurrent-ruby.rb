component 'rubygem-concurrent-ruby' do |pkg, settings, platform|
  # Projects may define a :rubygem_concurrent_ruby_version setting
  version = settings[:rubygem_concurrent_ruby_version] || '1.1.10'

  case version
  when '1.1.9'
    pkg.version '1.1.9'
    pkg.md5sum '417a23cac840f6ea8bdd0841429c3c19'
  when '1.1.10'
    pkg.version '1.1.10'
    pkg.md5sum '4588a61d5af26e9ee12e9b8babc1b755'
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

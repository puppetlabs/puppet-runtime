component 'rubygem-puppet' do |pkg, settings, platform|
  # Projects may define a :rubygem_puppet_version setting, or we use this
  # version by default
  version = settings[:rubygem_puppet_version] || '6.28.0'
  pkg.version version

  # There are 4 platform-specific puppet gems for each tag:
  #
  #   generic
  #   universal-darwin
  #   x64-mingw32
  #   x86_mingw32
  #
  # Always use the generic version below
  case version
  when '8.8.1'
    pkg.md5sum '2f039fa86f8bd02e1258bca40dcc9b6b'
  when '7.32.1'
    pkg.md5sum 'e4e91fae76bb76d4e899b9cf7aafe365'
  when '6.28.0'
    pkg.md5sum '31520d986869f9362c88c7d6a4a5c103'
  else
    raise "Invalid version #{version} for rubygem-puppet; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end
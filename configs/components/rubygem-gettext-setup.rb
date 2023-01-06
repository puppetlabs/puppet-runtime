component "rubygem-gettext-setup" do |pkg, settings, platform|
  version = settings[:rubygem_gettext_setup_version] || '1.1.0'
  pkg.version version

  case version
  when '1.1.0'
    pkg.sha256sum '2ad4fa99575d869f18056941d98dc9cb2a656abc7b991f360fbd3e32d28fd4ec'
  when '0.34'
    pkg.sha256sum 'ea9d6f6be56908d54af8c7bb246f133fa9f8f634011df135c0a87520be57d6ed'
  else
    raise "rubygem-gettext-setup version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

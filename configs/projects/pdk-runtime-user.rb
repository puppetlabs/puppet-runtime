project 'pdk-runtime-user.rb' do |proj|
  # This only applies to Windows builds and will direct the runtime to install
  # components in to LocalAppDataFolder. This means that consuming components will be
  # able to produce user scoped installs for PDK.
  proj.setting(:base_dir, 'LocalAppDataFolder')
  instance_eval File.read(File.join(File.dirname(__FILE__), 'pdk-runtime.rb'))
end

project 'pdk-runtime-system.rb' do |proj|
  # This only applies to Windows builds and will direct the runtime to install
  # components in to ProgramFiles64Folder.
  proj.setting(:base_dir, 'ProgramFiles64Folder')
  instance_eval File.read(File.join(File.dirname(__FILE__), 'pdk-runtime.rb'))
end

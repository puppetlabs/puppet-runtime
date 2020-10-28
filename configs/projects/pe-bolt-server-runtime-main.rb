project 'pe-bolt-server-runtime-main' do |proj|
  proj.setting(:pe_version, 'main')

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-pe-bolt-server.rb'))
end

project 'pe-bolt-server-runtime-2019.2.x' do |proj|
  proj.setting(:pe_version, '2019.2')

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-pe-bolt-server.rb'))
end


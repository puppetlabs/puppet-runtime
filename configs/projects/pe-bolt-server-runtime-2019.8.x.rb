project 'pe-bolt-server-runtime-2019.8.x' do |proj|
  proj.setting(:pe_version, 'master')

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-pe-bolt-server.rb'))
end

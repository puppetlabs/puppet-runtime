project 'pe-bolt-server-runtime-master' do |proj|
  proj.setting(:pe_version, 'master')

  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-pe-bolt-server.rb'))
end


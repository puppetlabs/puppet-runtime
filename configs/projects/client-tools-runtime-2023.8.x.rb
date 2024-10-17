project 'client-tools-runtime-2023.8.x' do |proj|
  proj.setting(:openssl_version, '3.0')

  # Common settings
  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-client-tools-runtime.rb'))
end
project 'client-tools-runtime-2019.8.x' do |proj|
  # Common settings
  instance_eval File.read(File.join(File.dirname(__FILE__), '_shared-client-tools-runtime.rb'))
end

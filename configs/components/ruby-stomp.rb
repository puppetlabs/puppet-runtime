component "ruby-stomp" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-ruby-stomp.rb')
end

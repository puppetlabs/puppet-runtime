component "ruby-augeas" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-ruby-augeas.rb')
end

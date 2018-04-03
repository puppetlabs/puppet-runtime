component "ruby-selinux" do |pkg, settings, platform|
  instance_eval File.read('configs/components/_base-ruby-selinux.rb')
end

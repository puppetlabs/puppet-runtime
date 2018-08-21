component "ruby-multi-stomp" do |pkg, settings, platform|
  settings[:additional_rubies].keys.each do |ruby_ver|
    ruby_settings = settings[:additional_rubies][ruby_ver]

    ruby_version = ruby_settings[:ruby_version]
    ruby_bindir = ruby_settings[:ruby_bindir]
    gem_home = ruby_settings[:gem_home]
    gem_install = ruby_settings[:gem_install]

    instance_eval File.read('configs/components/_base-ruby-stomp.rb')
  end
end

component "ruby-multi-augeas" do |pkg, settings, platform|
  settings[:additional_rubies].keys.each do |ruby_ver|
    ruby_settings = settings[:additional_rubies][ruby_ver]

    ruby_version = ruby_settings[:ruby_version]
    host_ruby = ruby_settings[:host_ruby]
    ruby_dir = ruby_settings[:ruby_dir]
    ruby_bindir = ruby_settings[:ruby_bindir]

    instance_eval File.read('configs/components/_base-ruby-augeas.rb')
  end
end

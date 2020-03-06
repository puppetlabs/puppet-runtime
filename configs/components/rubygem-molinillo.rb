component "rubygem-molinillo" do |pkg, settings, platform|
  pkg.version "0.6.6"
  pkg.md5sum "f0f9d1fbb7277e3e4ae6c4be81fc0a92"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

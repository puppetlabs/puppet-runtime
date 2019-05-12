component "rubygem-win32-service" do |pkg, settings, platform|
  pkg.version "2.1.4"
  pkg.md5sum "757db04649b7032ee5975467d81e43ab"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

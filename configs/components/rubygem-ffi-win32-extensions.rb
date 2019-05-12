component "rubygem-ffi-win32-extensions" do |pkg, settings, platform|
  pkg.version '1.0.3'
  pkg.md5sum "4fa31ebfa5ecb8e490064696cd2af88c"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

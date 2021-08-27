component "rubygem-molinillo" do |pkg, settings, platform|
  pkg.version "0.8.0"
  pkg.md5sum "877866cc996d5ce819dd8843b3116b5f"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

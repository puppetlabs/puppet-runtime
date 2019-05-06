component "rubygem-win32-process" do |pkg, settings, platform|
  pkg.version "0.7.5"
  pkg.md5sum "d7ff67c7934b0d6ab93030d2cc2fc4f0"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

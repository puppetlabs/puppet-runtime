component "rubygem-tty-reader" do |pkg, settings, platform|
  pkg.version "0.9.0"
  pkg.sha256sum 'c62972c985c0b1566f0e56743b6a7882f979d3dc32ff491ed490a076f899c2b1'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

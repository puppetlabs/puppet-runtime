component "rubygem-childprocess" do |pkg, settings, platform|
  pkg.version "4.1.0"
  pkg.sha256sum '3616ce99ccb242361ce7f2b19bf9ff3e6bc1d98b927c7edc29af8ca617ba6cd3'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

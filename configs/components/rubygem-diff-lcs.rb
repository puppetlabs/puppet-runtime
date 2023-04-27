component "rubygem-diff-lcs" do |pkg, settings, platform|
  pkg.version "1.5.0"
  pkg.sha256sum "49b934001c8c6aedb37ba19daec5c634da27b318a7a3c654ae979d6ba1929b67"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

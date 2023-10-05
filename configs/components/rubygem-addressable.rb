component "rubygem-addressable" do |pkg, settings, platform|
  pkg.version "2.8.5"
  pkg.sha256sum "63f0fbcde42edf116d6da98a9437f19dd1692152f1efa3fcc4741e443c772117"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

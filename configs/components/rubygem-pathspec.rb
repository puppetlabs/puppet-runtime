component "rubygem-pathspec" do |pkg, settings, platform|
  pkg.version "1.1.3"
  pkg.sha256sum "c4e7ff4c4019499488874e21c37a1e2473d5123cfce6f13ecb07f42c0f8c5d23"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

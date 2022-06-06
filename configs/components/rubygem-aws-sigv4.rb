component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.5.0"
  pkg.md5sum "a4625748054bc74daf69d67e5af3099d"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

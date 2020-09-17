component "rubygem-aws-sigv4" do |pkg, settings, platform|
  pkg.version "1.2.2"
  pkg.md5sum "49e0836d3af6ff97d01e15977ff85b12"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

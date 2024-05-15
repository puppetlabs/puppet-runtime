component "rubygem-childprocess" do |pkg, settings, platform|
  pkg.version "5.0.0"
  pkg.sha256sum '0746b7ab1d6c68156e64a3767631d7124121516192c0492929a7f0af7310d835'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

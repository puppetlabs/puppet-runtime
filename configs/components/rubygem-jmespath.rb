component "rubygem-jmespath" do |pkg, settings, platform|
  pkg.version "1.6.1"
  pkg.md5sum "3c84a5f234039163185a7ec31c628d0f"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

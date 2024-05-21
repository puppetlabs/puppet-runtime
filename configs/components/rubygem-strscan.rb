component "rubygem-strscan" do |pkg, settings, platform|
  pkg.version "3.1.0"
  pkg.sha256sum '01b8a81d214fbf7b5308c6fb51b5972bbfc4a6aa1f166fd3618ba97e0fcd5555'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

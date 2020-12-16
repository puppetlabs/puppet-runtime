component "rubygem-molinillo" do |pkg, settings, platform|
  pkg.version "0.7.0"
  pkg.md5sum "3da77c3c3b5d604aa654b29390f25cb0"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

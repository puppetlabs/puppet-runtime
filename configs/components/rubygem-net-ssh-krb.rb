component "rubygem-net-ssh-krb" do |pkg, settings, platform|
  pkg.version '0.5.1'
  pkg.md5sum "58f770a6a8eca61b5da467d584bb7016"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

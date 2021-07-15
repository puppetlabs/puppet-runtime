component 'rubygem-sys-filesystem' do |pkg, settings, platform|
  pkg.version '1.4.1'
  pkg.sha256sum '4e907d2a18b0d1a5785896c39e9742ad1dc1e1f772f8154c20e7a1b5a41a9154'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.apply_patch "resources/patches/rubygem-sys-filesystem/linux-statvfs.patch", destination: "#{settings[:gem_home]}/gems/sys-filesystem-#{pkg.get_version}", after: "install"
end

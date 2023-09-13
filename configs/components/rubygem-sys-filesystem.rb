component 'rubygem-sys-filesystem' do |pkg, settings, platform|
  pkg.version '1.4.4'
  pkg.sha256sum 'f5d3a19adf8249a8803a057534034cef6afa3f149fe1d07251cf76ee2c1ac59b'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

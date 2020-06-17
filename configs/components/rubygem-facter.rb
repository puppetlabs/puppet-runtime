component 'rubygem-facter' do |pkg, settings, platform|
  pkg.version '4.0.28'
  pkg.md5sum '92ff77b556cad16de75e47460dcbd3fd'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

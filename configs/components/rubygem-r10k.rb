component 'rubygem-r10k' do |pkg, settings, platform|
  pkg.version '3.15.4'
  pkg.sha256sum '7d6f37c998f825f61fe34b42492d65f044b8e41fdb728b87892ede6373f4cd09'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

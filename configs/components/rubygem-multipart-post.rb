component 'rubygem-multipart-post' do |pkg, settings, platform|
  pkg.version '2.2.3'
  pkg.md5sum 'ebcd6ee70446d58c85ceb926f664a883'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

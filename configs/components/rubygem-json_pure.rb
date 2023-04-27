component "rubygem-json_pure" do |pkg, settings, platform|
  pkg.version "2.6.3"
  pkg.sha256sum 'c39185aa41c04a1933b8d66d1294224743262ee6881adc7b5a488ab2ae19c74e'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

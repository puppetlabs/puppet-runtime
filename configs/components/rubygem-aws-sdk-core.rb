component "rubygem-aws-sdk-core" do |pkg, settings, platform|
  pkg.version "3.112.1"
  pkg.md5sum "ab921dc50a05ed758335554aed9c6593"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

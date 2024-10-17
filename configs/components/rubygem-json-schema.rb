component "rubygem-json-schema" do |pkg, settings, platform|
  pkg.version "5.0.1"
  pkg.sha256sum "bef71a82c600a42594911553522e143f7634affc198ed507ef3ded2f920a74a9"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

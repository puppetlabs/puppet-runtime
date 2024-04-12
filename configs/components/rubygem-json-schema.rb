component "rubygem-json-schema" do |pkg, settings, platform|
  pkg.version "4.3.1"
  pkg.sha256sum "ac35bfabf99eea2b8b45fbccbb714b399fbe7824c621fc985048a9c2e45d58d2"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

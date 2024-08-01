component "rubygem-cri" do |pkg, settings, platform|
  pkg.version "2.15.12"
  pkg.sha256sum "8abfe924ef53e772a8e4ee907e791d3bfcfca78bc62a5859e3b9899ba29956e5"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

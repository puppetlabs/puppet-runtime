component "rubygem-diff-lcs" do |pkg, settings, platform|
  pkg.version "1.5.1"
  pkg.sha256sum "273223dfb40685548436d32b4733aa67351769c7dea621da7d9dd4813e63ddfe"

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

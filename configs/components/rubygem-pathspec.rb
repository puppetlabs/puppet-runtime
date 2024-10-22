component "rubygem-pathspec" do |pkg, settings, platform|
  if settings[:ruby_version].to_f >= 3.1
    pkg.version "2.1.0"
    pkg.sha256sum "89e186d2aeb8b8237b2ad8ed04bf47907b7acd475afff290d3f271b5f84c4d24"
  else
    pkg.version "1.1.3"
    pkg.sha256sum "c4e7ff4c4019499488874e21c37a1e2473d5123cfce6f13ecb07f42c0f8c5d23"
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

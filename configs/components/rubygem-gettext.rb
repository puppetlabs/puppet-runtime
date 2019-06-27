component "rubygem-gettext" do |pkg, settings, platform|
  # Projects may define a :rubygem_gettext_version setting, or we use 3.2.2 by default:
  version = settings[:rubygem_gettext_version] || '3.2.2'
  pkg.version version

  case version
  when "3.2.2"
    pkg.md5sum "4cbb125f8d8206e9a8f3a90f6488e4da"
  when "3.2.9"
    pkg.md5sum "09a755cd03ab617835e20a2e910581f4"
  else
    raise "rubygem-gettext version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

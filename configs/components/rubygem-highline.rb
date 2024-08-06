component 'rubygem-highline' do |pkg, settings, _platform|
  version = settings[:rubygem_highline_version] || '2.1.0'
  pkg.version version

  case version
  when '2.1.0'
    pkg.md5sum '4209083bda845d47dcc05b7ab23f25fd'
  when '3.0.1'
    pkg.sha256sum 'ca18b218fd581b1fae832f89bfeaf2b34d3a93429c44fd4411042ffce286f009'
  when '3.1.0'
    pkg.sha256sum '14183e4628f41fb4211766d0d38fb153f01f1ec39adfa83f5f7c6e6ebeb2b8eb'
  else
    raise "rubygem-highline version #{version} has not been configured; Cannot continue."
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment "GEM_HOME", (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end

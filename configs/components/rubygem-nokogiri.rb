component 'rubygem-nokogiri' do |pkg, _settings, _platform|
  pkg.version '1.12.5'
  pkg.sha256sum '2b20905942acc580697c8c496d0d1672ab617facb9d30d156b3c7676e67902ec'
  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.build_requires 'rubygem-racc'
  pkg.build_requires 'rubygem-mini_portile2'

  # Overwrite the base rubygem's default GEM_HOME with the vendor gem directory
  # shared by puppet and puppetserver. Fall-back to gem_home for other projects.
  pkg.environment 'GEM_HOME', (settings[:puppet_gem_vendor_dir] || settings[:gem_home])
end

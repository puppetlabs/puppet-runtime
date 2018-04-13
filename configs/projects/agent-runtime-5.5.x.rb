project 'agent-runtime-5.5.x' do |proj|
  proj.setting :ruby_version, '2.4.4'
  proj.setting :augeas_version, '1.10.1'

  # Common agent settings:
  instance_eval File.read(File.join(File.dirname(__FILE__), 'base-agent-runtime.rb'))

  # Directory for gems shared by puppet and puppetserver
  proj.setting(:puppet_gem_vendor_dir, File.join(proj.libdir, "ruby", "vendor_gems"))

  # Dependencies specific to the 5.5.x branch
  proj.component 'rubygem-gettext-setup'
  proj.component 'rubygem-multi_json'
  proj.component 'rubygem-highline'
  proj.component 'rubygem-trollop'
  proj.component 'rubygem-hiera-eyaml'
end

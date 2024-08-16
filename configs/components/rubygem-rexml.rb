component 'rubygem-rexml' do |pkg, settings, platform|
  pkg.version '3.3.5'
  pkg.md5sum 'cdd5c83f1d7230a7d44406f69e9f3d2d'

  # If the platform is solaris with sparc architecture in agent-runtime-7.x project, we want to gem install rexml
  # ignoring the dependencies, this is because the pl-ruby version used in these platforms is ancient so it gets
  # confused when installing rexml. It tries to install rexml's dependency 'strscan' by building native extensions
  # but fails. We can ignore insalling that since strscan is already shipped with ruby 2 as its default gem.
  if platform.name =~ /solaris-(10|11)-sparc/ && settings[:ruby_version].to_i < 3
    settings["#{pkg.get_name}_gem_install_options".to_sym] = "--ignore-dependencies"
  end
  
  instance_eval File.read('configs/components/_base-rubygem.rb')
end

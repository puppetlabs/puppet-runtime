component 'rubygem-mini_portile2' do |pkg, _settings, _platform|
  pkg.version '2.8.0'
  pkg.sha256sum '1e06b286ff19b73cfc9193cb3dd2bd80416f8262443564b25b23baea74a05765'

  instance_eval File.read('configs/components/_base-rubygem.rb')

  pkg.environment 'GEM_HOME', settings[:gem_home]
end

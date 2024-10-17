component 'rubygem-winrm' do |pkg, settings, platform|
  if settings[:ruby_version].to_f >= 3.2
    pkg.version '2.3.9'
    pkg.md5sum '3ee81372528048b8305334ab6f36b4e9'
  else
    pkg.version '2.3.6'
    pkg.md5sum 'a99f8e81343f61caa441eb1397a1c6ae'
  end

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

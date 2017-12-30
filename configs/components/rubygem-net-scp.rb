component "rubygem-net-scp" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "1.2.1"
  pkg.md5sum "abeec1cab9696e02069e74bd3eac8a1b"
  pkg.url "https://rubygems.org/downloads/net-scp-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/net-scp-#{pkg.get_version}.gem"

  pkg.build_requires "rubygem-net-ssh"

  if platform.is_windows?
    pkg.environment "PATH", "$(shell cygpath -u #{settings[:gcc_bindir]}):$(shell cygpath -u #{settings[:ruby_bindir]}):$(shell cygpath -u #{settings[:bindir]}):/cygdrive/c/Windows/system32:/cygdrive/c/Windows:/cygdrive/c/Windows/System32/WindowsPowerShell/v1.0"
  end

  pkg.install do
    ["#{settings[:gem_install]} net-scp-#{pkg.get_version}.gem"]
  end
end

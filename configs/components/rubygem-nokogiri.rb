component "rubygem-nokogiri" do |pkg, settings, platform|
  instance_eval File.read('configs/components/base-rubygem.rb')
  pkg.version "1.6.8"
  pkg.url "https://rubygems.org/downloads/nokogiri-#{pkg.get_version}.gem"
  pkg.mirror "#{settings[:buildsources_url]}/nokogiri-#{pkg.get_version}.gem"
  pkg.md5sum "51402a536f389bfcef0ff1600b8acff5"

  pkg.build_requires "rubygem-mini_portile2"
  pkg.build_requires "rubygem-pkg-config"

  # Standard build process for non cross-compiled platforms to ensure we build
  # against our vendored libxml2 and libxslt
  pkg.install do
    [
      "#{settings[:gem_install]} nokogiri-#{pkg.get_version}.gem -- --use-system-libraries --with-xml2-lib=/opt/puppetlabs/puppet/lib --with-xml2-include=/opt/puppetlabs/puppet/include/libxml2 --with-xslt-lib=/opt/puppetlabs/puppet/lib --with-xslt-include=/opt/puppetlabs/puppet/include/libxslt"
    ]
  end
end

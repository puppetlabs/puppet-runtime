component 'libpsl' do |pkg, settings, platform|
  pkg.version '0.21.5'
  pkg.url "https://github.com/rockdaboot/libpsl/releases/download/#{pkg.get_version}/libpsl-#{pkg.get_version}.tar.gz"
  pkg.mirror "https://artifactory.delivery.puppetlabs.net/artifactory/generic__buildsources/buildsources/libpsl-0.21.5.tar.gz"
  pkg.sha256sum "1dcc9ceae8b128f3c0b3f654decd0e1e891afc6ff81098f227ef260449dae208"

  if platform.is_aix?
    pkg.environment "MAKE", 'gmake'
    pkg.environment "PATH", "$(PATH):/opt/freeware/bin"
  elsif platform.is_solaris?
    pkg.environment "MAKE", 'gmake'
    pkg.environment "PATH", "/opt/pl-build-tools/bin:$(PATH)"
    pkg.environment "CFLAGS", "-I/opt/csw/include"
    pkg.environment "LDFLAGS", "-L/opt/csw/lib"
  end

  pkg.configure do
    ["./configure --prefix=#{settings[:prefix]}"]
  end

  pkg.build do
    ["#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1)"]
  end

  pkg.install do
    ["#{platform[:make]} VERBOSE=1 -j$(shell expr $(shell #{platform[:num_cores]}) + 1) install"]
  end
end

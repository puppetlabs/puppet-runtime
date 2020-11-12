component 'logrotate' do |pkg, _settings, platform|

  # pkg.version '3.17.0'
  # pkg.sha256sum '5db8cf4786e0abeeec64f852d605ef702bfcf18f4d7938dce7d7a00ad4de787c'
  # pkg.url "https://github.com/logrotate/logrotate/releases/download/#{pkg.version}/logrotate-#{pkg.version}.tar.gz"
  
  pkg.url 'git@github.com:logrotate/logrotate.git'
  pkg.ref 'refs/tags/3.17.0'

  if platform.is_solaris?
    # Build Command
    pkg.build do
      ['/usr/bin/gmake ']
    end

    # Install Command
    pkg.install do
      ['/usr/bin/gmake install']
    end
  end
end

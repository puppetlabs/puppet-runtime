component "rubygem-tty-screen" do |pkg, settings, platform|
  pkg.version "0.8.1"
  pkg.sha256sum '6508657c38f32bdca64880abe201ce237d80c94146e1f9b911cba3c7823659a2'

  instance_eval File.read('configs/components/_base-rubygem.rb')
end

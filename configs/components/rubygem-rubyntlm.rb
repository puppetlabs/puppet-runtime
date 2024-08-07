component 'rubygem-rubyntlm' do |pkg, settings, platform|
  # Do not update past this version without solving the jruby/ruby2.7 issue described in the commit
  # message this comment is associated with.
  pkg.version '0.6.3'
  pkg.md5sum 'e1f7477acf8a7d3effb2a3fb931aa84c'
  instance_eval File.read('configs/components/_base-rubygem.rb')
end
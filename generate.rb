#!/usr/bin/env ruby

require 'bundler'
require 'net/http'

lockfile = ARGV.first
if lockfile.nil?
  warn 'Usage: generate.rb /path/to/Gemfile.lock'
  exit 1
end

unless File.exist? lockfile
  warn "Lockfile #{lockfile} does not exist"
  exit 1
end

unless File.readable? lockfile
  warn "Lockfile #{lockfile} could not be read"
  exit 1
end

# Parse the Gemfile.lock and build a map or gem name to version
bundle = Bundler::LockfileParser.new(Bundler.read_file(lockfile))
gem_name_to_version = bundle.specs.each_with_object({}) { |gem_object, acc| acc[gem_object.name] = gem_object.version }

# Print a warning if the version defined in the component defintion is 
# Older than the version in the Gemfile.lock
def check_update(component_def, spec, gem_name_to_version)
  component_def.each_line do |line|
    # TODO: Some of the component files handle multiple versions with a case statement (for example net-ssh). 
    # Add more logic to compare each of those versions. For now there are only a hand full. 
    if line =~ /pkg.version/
      ver = Gem::Version.new(line.scan(/\d\.*/).join(''))
      if gem_name_to_version[spec.name] > ver
        warn "Update needed for: #{spec.name} \nUpgrade from #{ver} to #{gem_name_to_version[spec.name]}\n\n"
      end
    end
  end
end

http = Net::HTTP.start('artifactory.delivery.puppetlabs.net', use_ssl: true)

bundle.specs.each do |s|
  filename = "configs/components/rubygem-#{s.name}.rb"
  next unless File.exist?(filename)
  # Check if an update is needed by comparing version in component defintion to version in lockfile
  check_update(File.read(filename), s, gem_name_to_version)
  # Warn if the gem is not mirrored in artifactory
  resp = http.head("/artifactory/generic__buildsources/buildsources/#{s.name}-#{s.version}.gem")
  unless resp.is_a?(Net::HTTPSuccess)
    warn "Update Needed for #{s.name}:\n!mirrorsource https://rubygems.org/downloads/#{s.name}-#{s.version}.gem\n\n"
  end
end

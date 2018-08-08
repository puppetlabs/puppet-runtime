# **********************
# rbconfig-update.rb
#
# This script is intended to write a new rbconfig file that is
# a copy of an existing rbconfig with updated entries.
#
# entries to update should passed in as a string that can be
# evaluated as a ruby array in the first argument to the script
#
# **********************

# replace_line
#
# The following replaces any configuration line in an rbconfig
# that matches any of the key value pairs listed in the CHANGES
# hash
def replace_line(changes, line, file)
  changes.each do |change_key, change_value|
    if line.strip.start_with?("CONFIG[\"#{change_key}\"]")
      puts "Updating #{change_key} to CONFIG[\"#{change_key}\"] = \"#{change_value}\""
      file.puts line.sub(/CONFIG.*/, "CONFIG[\"#{change_key}\"] = \"#{change_value}\"")
      return true
    end
  end
  false
end


# the following creates a new_rbconfig.rb file that is a copy of
# the rbcofig read from ORIGIN_RBCONF_LOCATION with replacements for
# anything listed in the CHANGES hash
new_rbconfig = File.open("new_rbconfig.rb", "w")
rbconfig_location = File.join(ARGV[1], "rbconfig.rb")
File.open(rbconfig_location, "r").readlines.each do |line|
  unless replace_line(instance_eval(ARGV[0]), line, new_rbconfig)
    new_rbconfig.puts line
  end
end
new_rbconfig.close

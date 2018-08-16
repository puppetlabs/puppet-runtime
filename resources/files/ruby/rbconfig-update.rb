# **********************
# rbconfig-update.rb
#
# This script is intended to write a new rbconfig file that is
# a copy of an existing rbconfig with updated entries. It will
# also produce a copy of the original with raise replaced with
# warn.
#
# entries to update should passed in as a string that can be
# evaluated as a ruby hash in the first argument to the script
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
      return line.sub(/CONFIG.*/, "CONFIG[\"#{change_key}\"] = \"#{change_value}\"")
    end
  end
  line
end


# the following creates two files:
# new_rbconfig.rb that is a copy of the rbcofig read from ARGV1
# with replacements for anything provided in the hash passed in as ARGV0
#
# and original_rbconfig.rb that is a copy of rbconfig with all exceptions changed
# to warnings.
begin
  new_rbconfig = File.open("new_rbconfig.rb", "w")
  copy_rbconfig = File.open("original_rbconfig.rb", "w")
  File.open(File.join(ARGV[1], "rbconfig.rb"), "r").readlines.each do |line|
    new_rbconfig.puts replace_line(instance_eval(ARGV[0]), line, new_rbconfig)
    copy_rbconfig.puts line.gsub('raise', 'warn')
  end
ensure
  new_rbconfig.close
  copy_rbconfig.close
end

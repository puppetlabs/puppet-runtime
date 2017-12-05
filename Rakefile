require 'json'

RAKE_ROOT = File.expand_path(File.dirname(__FILE__))

begin
  load File.join(RAKE_ROOT, 'ext', 'packaging', 'packaging.rake')
rescue LoadError
end

namespace :component do
  desc "Display currently promoted ref for component"
  task :check, [:component] do |t,args|
    abort 'USAGE: rake component:check[component]' unless args[:component]

    config = get_component_config(args[:component])

    puts config["ref"]
  end

  desc "Update component config to promote a new version"
  task :promote, [:component, :version, :ref] do |t,args|
    abort 'USAGE: rake component:promote[component,version,ref]' unless args[:component] && args[:version] && args[:ref]

    config = get_component_config(args[:component])
    config["version"] = args[:version]
    config["ref"] = args[:ref]

    File.open(component_config_file(args[:component]), 'w') do |f|
      f.write(JSON.pretty_generate(config))
    end
  end
end

# Legacy task name.
task :promote_component, [:component, :version, :ref] => "component:promote"

def component_config_file(component)
  "configs/components/#{component}.json"
end

def get_component_config(component)
  conf = component_config_file(component)
  abort "No component config file '#{conf}'" unless File.exist?(conf)

  JSON.parse(File.read(conf))
end

build_defs_file = File.join(RAKE_ROOT, 'ext', 'build_defaults.yaml')
if File.exist?(build_defs_file)
  begin
    require 'yaml'
    @build_defaults ||= YAML.load_file(build_defs_file)
  rescue Exception => e
    STDERR.puts "Unable to load yaml from #{build_defs_file}:"
    raise e
  end
  @packaging_url  = @build_defaults['packaging_url']
  @packaging_repo = @build_defaults['packaging_repo']
  raise "Could not find packaging url in #{build_defs_file}" if @packaging_url.nil?
  raise "Could not find packaging repo in #{build_defs_file}" if @packaging_repo.nil?

  namespace :package do
 #   desc "Bootstrap packaging automation, e.g. clone into packaging repo"
    task :bootstrap do
      if File.exist?(File.join(RAKE_ROOT, "ext", @packaging_repo))
        puts "It looks like you already have ext/#{@packaging_repo}. If you don't like it, blow it away with package:implode."
      else
        cd File.join(RAKE_ROOT, 'ext') do
          %x{git clone #{@packaging_url}}
        end
      end
    end
 #   desc "Remove all cloned packaging automation"
    task :implode do
      rm_rf File.join(RAKE_ROOT, "ext", @packaging_repo)
    end
  end
end

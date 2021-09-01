# coding: utf-8
namespace :vanagon do |args|
  desc 'Show component diff'
  task(:component_diff) do
    require 'tempfile'
    require 'highline/import'
    require 'json'
    require 'parallel'
    require 'hashdiff'
    require 'optparse'

    class String
      @@markdown = false
      @@diff_open = false

      class << self
        def format_as_markdown
          @@markdown = true
        end

        def is_in_markdown?
          @@markdown
        end

        def start_diff(alternative = '')
          return alternative unless @@markdown
          @@diff_open = true
          '```diff'
        end

        def end_diff(alternative = '')
          return alternative unless @@markdown
          @@diff_open = false
          '```'
        end

        def start_collapsible(text)
          return text unless @@markdown
          text.delete!('`~*_').gsub!('&nbsp;','')
          "<details>\n  <summary>#{text}</summary>\n\n"
        end

        def end_collapsible
          return '' unless @@markdown
          '</details>'
        end

        def hr
          return "\n---\n" if @@markdown
          ''
        end
      end

      def +(text)
        "#{self} #{text}"
      end

      def red
        return @@diff_open ? self : "#{self} :x:" if @@markdown
        "\e[31m#{self}\e[0m"
      end

      def green
        return @@diff_open ? self : "#{self} :white_check_mark:" if @@markdown
        "\e[32m#{self}\e[0m"
      end

      def cyan
        return self if @@markdown
        "\e[36m#{self}\e[0m"
      end

      def code
        return "`#{self}`" if @@markdown
        self.italic
      end

      def strike
        return "~~#{self.strip}~~" if @@markdown
        self
      end

      def bold
        return "**#{self.strip}**" if @@markdown
        "\e[1m#{self}\e[22m"
      end

      def italic
        return "_#{self.strip}_" if @@markdown
        "\e[3m#{self}\e[23m"
      end

      def tab(number = 1)
        return @@diff_open ? self : "#{'&nbsp;'*4*number}#{self}" if @@markdown
        "#{' '*4*number}#{self}"
      end

      def h(number)
        return "#{'#'*number}" + self if @@markdown
        self.bold
      end

      def unwrap
        return self unless @@markdown
        self.gsub! /([^\n])\n([^\n])/, '\1 \2'
      end
    end

    MAX_CPU = Etc.nprocessors - 1
    TASK_NAME = ARGV.first

    def vanagon_inspect(project, ref, platforms)
      files = {}

      platforms.each do |platform|
        files[platform] = Tempfile.new('vanagon_component_diff')
      end
      prev_branch = `git rev-parse --abbrev-ref HEAD`

      `git checkout -q #{ref}`

      Parallel.each(files, max_threads: MAX_CPU) do |platform, file|
        `bundle exec vanagon inspect #{project} #{platform} > '#{file.path}' 2> /dev/null || echo '{}' > '#{file.path}'`
      end

      `git checkout -q #{prev_branch}`
      files
    end

    git_from_rev = 'origin/master'
    git_to_rev = 'HEAD'
    default_projects = ['agent-runtime-main']
    projects = []
    default_platforms = ['el-7-x86_64']
    platforms = []

    parser = OptionParser.new do |opts|
      opts.banner = "Usage: rake #{TASK_NAME} -- [options]"

      opts.on('-f', '--from from_rev', "from git revision (default: #{git_from_rev})") do |from_rev|
        git_from_rev = from_rev
      end

      opts.on('-t', '--to to_rev', "to git revision (default: #{git_to_rev})") do |to_rev|
        git_to_rev = to_rev
      end

      opts.on('-P', '--project vanagon_project', "vanagon project name (default: #{default_projects}, can be specified multiple times); use 'all' to add all available") do |project_name|
        if project_name == 'all'
          Dir.entries('configs/projects').each do |file_name|
            next unless file_name.end_with?('.rb')
            next if file_name.start_with?('_')
            projects << File.basename(file_name, '.rb')
          end
        else
          projects << project_name
        end
      end

      opts.on('-p', '--platform vanagon_platform', "vanagon platform names (default: #{default_platforms}, can be specified multiple times); use 'all' to add all available") do |platform_name|
        if platform_name == 'all'
          Dir.entries('configs/platforms').each do |file_name|
            next unless file_name.end_with?('.rb')
            platforms << File.basename(file_name, '.rb')
          end
        else
          platforms << platform_name
        end
      end

      opts.on('-i', '--interactive', 'interactive mode (prompt for settings)') do
        git_from_rev = ask('Enter Git From Rev: ') { |q| q.default = git_from_rev }
        git_to_rev = ask('Enter Git To Rev: ') { |q| q.default = git_to_rev }
        projects = ask("Enter project name (default: #{default_projects.first}, write 'done' to finish project input): ") do |q|
          q.default = default_projects
          q.gather = "done"
        end
        platforms = ask("Enter platform name (default: #{default_platforms.first}, write 'done' to finish platform input): ") do |q|
          q.default = default_platforms
          q.gather = "done"
        end
      end

      opts.on('-m', '--markdown', 'format output with markdown for GitHub') do
        String.format_as_markdown
      end

      opts.on('-h', '--help', 'this message') do
        puts opts
        exit 1
      end
    end

    args = parser.order!(ARGV) {}
    parser.parse!(args)

    if platforms.empty?
      platforms = default_platforms
    end

    if projects.empty?
      projects = default_projects
    end

    puts <<~DISCLAIMER.unwrap
      #{'⚠️ DISCLAIMER'.h(3)}

      This task is still experimental, it can be invoked locally provided that
      development dependencies are installed (#{'bundle install --with development'.code}).

      Ensure all your local changes are committed, then run
      #{"bundle exec rake #{TASK_NAME} -- [options]".code}.

      Run the task with #{'--help'.code} to see all available options. If you notice unexpected
      behavior or want to suggest improvements, ping #prod-puppet-agent on Slack.

    DISCLAIMER

    puts "Here is what your code changes would affect:".h(1)
    puts
    projects.each do |project|
      puts "Project #{project.code}".h(2)
      new_files = vanagon_inspect(project, git_to_rev, platforms)
      old_files = vanagon_inspect(project, git_from_rev, platforms)

      old, new = {}, {}
      Parallel.each(old_files.zip(new_files), in_threads: MAX_CPU) do |old_file, new_file|
        old[old_file.first] = JSON.parse(old_file.last.read)
        new[new_file.first] = JSON.parse(new_file.last.read)
      end

      old_hash = old.each_with_object({}) do |k, v|
        v[k.first] ||= {} # k.first = platform name
        k.last.each do |component| # k.last = components
          v[k.first][component.delete("name")] = component
        end
      end

      new_hash = new.each_with_object({}) do |k, v|
        v[k.first] ||= {}
        k.last.each do |component|
          v[k.first][component.delete("name")] = component
        end
      end

      diff = {}
      Parallel.each(platforms, in_threads: MAX_CPU) do |platform|
        diff[platform] = Hashdiff.diff(old_hash[platform], new_hash[platform], delimiter: '|') # TODO investigate if the array_path option is useful
      end

      changes_found = false
      diff.each do |platform, diff|
        diff.reject! do |hunk|
          # these are repos added by vanagon using SecureRandom hashes so we should exclude them from the diff output
          hunk[1].include?('platform|provisioning') &&
            hunk.last.is_a?(String) &&
            hunk.last.start_with?('curl --silent --show-error --fail --location -o')
        end

        next if diff.empty?
        puts String.hr if changes_found
        changes_found = true
        puts

        puts "Platform name:".h(3) + platform.cyan.code
        ordered_diff = diff.each_with_object({}) do |k, v|
          name, field = k[1].match(/^([a-zA-Z\-._0-9]+)\|?(.*)?/).captures
          if field.nil? || field.empty?
            case k.first
            when '+'
              puts "Component '#{name}' was newly added, not showing diff for it".tab.green
            when '-'
              puts "Component '#{name}' was removed, not showing diff for it".tab.red
            end
            puts
            next
          end

          diff = [k[0], k[2], k[3]].compact
          v[name] ||= {}
          v[name][field] ||= []
          v[name][field] << diff unless v[name][field].include?(diff)
        end

        ordered_diff.each do |component, field_hash|
          puts String.start_collapsible("Component".tab.bold + "'#{component.cyan}'")

          field_hash.each do |field, diff|
            puts "Field:".tab(2).bold + field.code.cyan

            puts String.start_diff(('-'*20).tab(2))
            diff.each do |line|
              case line.first
              when '-'
                puts "- #{line[1]}".tab(2).red
              when '+'
                puts "+ #{line[1]}".tab(2).green
              when '~'
                puts "- #{line[1]}".tab(2).red
                puts "+ #{line[2]}".tab(2).green
              end
            end
            puts String.end_diff
          end
          puts String.end_collapsible
        end
      end
      puts "Nothing is affected 😊" if !changes_found
    end
    exit 0
  end
end

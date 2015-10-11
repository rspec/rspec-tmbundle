require 'stringio'
require 'cgi'
require 'shellwords'
require 'open3'
require 'yaml'

module RSpec
  module Mate
    class Runner
      LAST_REMEMBERED_FILE_CACHE = "/tmp/textmate_rspec_last_remembered_file_cache.txt"
      LAST_RUN_CACHE             = "/tmp/textmate_rspec_last_run.yml"
      
      def run_files(options={})
        files = ENV['TM_SELECTED_FILES'] ? Shellwords.shellwords(ENV['TM_SELECTED_FILES']) : ["spec/"]
        options.merge!({:files => files})
        run(options)
      end

      def run_file(options={})
        options.merge!({:files => [single_file]})
        run(options)
      end

      def run_last_remembered_file(options={})
        options.merge!({:files => [last_remembered_single_file]})
        run(options)
      end

      def run_again
        run(:run_again => true)
      end
      
      def run_focussed(options={})
        options.merge!(
          {
            :files => [single_file],
            :line  => ENV['TM_LINE_NUMBER']
          }
        )

        run(options)
      end

      def run(options)
        if options.delete(:run_again)
          argv = load_argv_from_last_run
        else
          argv = build_argv_from_options(options)
          save_as_last_run(argv)
        end
        run_rspec(argv)
      end
      
      def run_rspec(argv)
        stderr     = StringIO.new
        old_stderr = $stderr
        $stderr    = stderr

        Dir.chdir(project_directory) do
          cmd = 
            if use_binstub?
              %w(bin/rspec) + argv
            elsif gemfile?
              %w(bundle exec rspec) + argv
            else
              %w(rspec) + argv
            end
          Open3.popen3(*cmd) do |i, out, err, thread|
            stderr_thread = Thread.new do
              while (line = err.gets) do
                stderr.puts line
              end
            end
            while (line = out.gets) do
              $stdout.puts line
              $stdout.flush
            end
            stderr_thread.join
          end
        end
      ensure
        unless stderr.string == ""
          $stdout <<
            "<pre class='stderr'>" <<
              CGI.escapeHTML(stderr.string) <<
            "</pre>"
        end

        $stderr = old_stderr
      end

      def save_as_last_remembered_file(file)
        File.open(LAST_REMEMBERED_FILE_CACHE, "w") do |f|
          f << file
        end
      end


      def rspec_version
        @rspec_version ||= begin
          version = if gemfile?
            specs = File.readlines(File.join(ENV['TM_PROJECT_DIRECTORY'], 'Gemfile.lock'))
            # RegExp taken from https://github.com/bundler/bundler/blob/master/lib/bundler/lockfile_parser.rb
            specs.detect{ |line| line.match(%r{^ {4}rspec-core(?: \(([^-]*)(?:-(.*))?\))?$}) } && $1 or raise "'rspec' not found in Gemfile.lock!"
          elsif use_binstub?
            Dir.chdir(ENV["TM_PROJECT_DIRECTORY"]) do
              `bin/rspec --version`.chomp
            end
          else
            Dir.chdir(ENV["TM_PROJECT_DIRECTORY"]) do
              `rspec --version`.chomp
            end
          end
          raise "Could not determine RSpec version." if version == ""
          version
        end
      end

      def rspec3?
        rspec_version.split(".").first.to_i >= 3
      end
      
    private

      def build_argv_from_options(options)
        default_formatter = rspec3? ? 'RSpec::Mate::Formatters::TextMateFormatter' : 'textmate'
        formatter  = ENV['TM_RSPEC_FORMATTER'] || default_formatter

        if rspec3?
          # If :line is given, only the first file from :files is used. This should be ok though, because
          # :line is only ever set in #run_focussed, and there :files is always set to a single file only.
          argv = options[:line] ? ["#{options[:files].first}:#{options[:line]}"] : options[:files].dup
        else
          argv = options[:files].dup
          if options[:line]
            argv << '--line'
            argv << options[:line]
          end
        end

        argv << '--format' << formatter
        argv << '-r' << File.join(File.dirname(__FILE__), 'text_mate_formatter') if formatter == 'RSpec::Mate::Formatters::TextMateFormatter'
        argv << '-r' << File.join(File.dirname(__FILE__), 'filter_bundle_backtrace')

        if ENV['TM_RSPEC_OPTS']
          argv += ENV['TM_RSPEC_OPTS'].split(" ")
        end
        
        argv
      end
      
      def last_remembered_single_file
        file = File.read(LAST_REMEMBERED_FILE_CACHE).strip

        if file.size > 0
          File.expand_path(file)
        end
      end

      def save_as_last_run(args)
        File.open(LAST_RUN_CACHE, "w") do |f|
          f.write YAML.dump(args)
        end
      end

      def load_argv_from_last_run
        YAML.load_file(LAST_RUN_CACHE)
      end

      def project_directory
        File.expand_path(ENV['TM_PROJECT_DIRECTORY']) rescue File.dirname(single_file)
      end

      def single_file
        File.expand_path(ENV['TM_FILEPATH'])
      end
    end
  end
end

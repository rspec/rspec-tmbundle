require "bundler"

LAST_RUN_FILENAME = "/tmp/textmate_rspec_last_run"

def run_rspec(*args)
  Dir.chdir ENV["TM_PROJECT_DIRECTORY"]
  save_as_last_run(args)
  seed = rand(65535)
  args << "--order" << "rand:#{seed}"
  if rspec_3?
    args << "-r" << "#{__dir__}/mate/text_mate_formatter" << "--format" << "RSpec::Mate::Formatters::TextMateFormatter"
  elsif rspec_2_14?
    args << "-r" << "#{__dir__}/mate/text_mate_formatter_2_14" << "--format" << "RSpec::Mate::Formatters::TextMateFormatter_2_14"
  else
    args << "--format" << "textmate"
  end
  remove_rbenv_from_env
  if binstub_available?
    system("bin/rspec", *args)
  else
    puts "No binstubs available, falling back to bundle exec ...<br>"
    system("bundle", "exec", "rspec", *args)
  end
end

def run_rspec_in_terminal(*args)
  require "shellwords"
  
  shellcmd = "cd #{Shellwords.escape ENV["TM_PROJECT_DIRECTORY"]}; "
  shellcmd << "#{binstub_available? ? 'bin/rspec' : 'bundle exec rspec'} " + args.map{ |arg| Shellwords.escape(arg) }.join(" ")
 
  applescript = %{
    tell application "Terminal" to activate
    tell application "System Events"
    	tell process "Terminal" to keystroke "t" using command down
    end tell
    tell application "Terminal"
      do script "#{shellcmd.gsub('\\', '\\\\\\\\').gsub('"', '\\"')}" in the last tab of window 1
    end tell
  }

  open("|osascript", "w") { |io| io << applescript }
end

def rerun_rspec
  run_rspec *load_last_run_args
end

def rerun_rspec_in_terminal
  run_rspec_in_terminal *load_last_run_args
end

def save_as_last_run(args)
  File.open(LAST_RUN_FILENAME, "w") do |f|
    f.puts Marshal.dump(args)
  end
end

def load_last_run_args
  Marshal.load(File.read(LAST_RUN_FILENAME))
end

def rspec_version
  @rspec_version ||= begin
    specs = Bundler::LockfileParser.new(Bundler.read_file(Bundler.default_lockfile)).specs
    specs.detect{ |s| s.name == "rspec-core" }.version
  end
end

def rspec_3?
  rspec_version.release >= Gem::Version.new("3")
end

def rspec_2_14?
  rspec_version.to_s.start_with?("2.14")
end

def binstub_available?
  File.exist?(ENV["TM_PROJECT_DIRECTORY"] + "/bin/rspec")
end

# See https://github.com/sstephenson/rbenv/issues/121#issuecomment-12735894
def remove_rbenv_from_env
  rbenv_root = `rbenv root 2>/dev/null`.chomp

  unless rbenv_root.empty?
    re = /^#{Regexp.escape rbenv_root}\/(versions|plugins|libexec)\b/
    paths = ENV["PATH"].split(":")
    paths.reject! {|p| p =~ re }
    ENV["PATH"] = paths.join(":")
    
    ENV.each{ |name, value| ENV[name] = nil if name =~ /^RBENV_/ }
  end
end
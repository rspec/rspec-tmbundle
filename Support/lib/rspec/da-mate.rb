LAST_RUN_FILENAME = "/tmp/textmate_rspec_last_run"

def run_rspec(*args)
  Dir.chdir ENV["TM_PROJECT_DIRECTORY"]
  save_as_last_run(args)
  seed = rand(65535)
  args += %W(--format textmate --order rand:#{seed})
  if binstub_available?
    system("bin/rspec", *args)
  elsif zeus_available?
    system("zeus", "rspec", *args)
  else
    puts "Neither binstubs nor zeus available, falling back to bundle exec ...<br>"
    system("bundle", "exec", "rspec", *args)
  end
end

def run_rspec_in_terminal(*args)
  require "shellwords"
  
  shellcmd = "cd #{Shellwords.escape ENV["TM_PROJECT_DIRECTORY"]}; "
  shellcmd << "#{binstub_available? ? 'bin/rspec' : 'bundle exec rspec'} #{args.join(' ')}"
   
  applescript = %{
    tell application "Terminal" to activate
    tell application "System Events"
    	tell process "Terminal" to keystroke "t" using command down
    end tell
    tell application "Terminal"
      do script "#{shellcmd}" in the last tab of window 1
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

def binstub_available?
  File.exist?(ENV["TM_PROJECT_DIRECTORY"] + "/bin/rspec")
end

def zeus_available?
  File.exist?(ENV["TM_PROJECT_DIRECTORY"] + "/.zeus.sock")
end
LAST_RUN_FILENAME = "/tmp/textmate_rspec_last_run"

def run_rspec(*args)
  save_as_last_run(args)
  seed = rand(65535)
  args += %W(--format textmate --order rand:#{seed})
  unless run_with_echo("zeus", "rspec", *args)
    puts "zeus not available, falling back to bundle exec ...<br>"
    run_with_echo("bundle", "exec", "rspec", *args)
  end
end

def rerun_rspec
  run_rspec *load_last_run_args
end

def save_as_last_run(args)
  File.open(LAST_RUN_FILENAME, "w") do |f|
    f.puts Marshal.dump(args)
  end
end

def load_last_run_args
  Marshal.load(File.read(LAST_RUN_FILENAME))
end

def run_with_echo(*args)
  puts args.map{ |a| a.sub(Dir.pwd, ".") }.join(" "), "<br>"
  system *args
end
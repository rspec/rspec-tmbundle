ENV['TM_PROJECT_DIRECTORY'] ||= '.'

require 'stringio'
require 'rspec/mate'
require 'rspec/core'
require 'rspec/core/sandbox'

RSpec.configure do |config|

  # See https://github.com/rspec/rspec-core/blob/5bee47543e78cf769ee4812c3bf7c00a91765b3a/spec/support/sandboxing.rb
  config.around(:example, :sandboxed) do |ex|
    RSpec::Core::Sandbox.sandboxed do |config|
      # If there is an example-within-an-example, we want to make sure the inner example
      # does not get a reference to the outer example (the real spec) if it calls
      # something like `pending`
      config.before(:context) { RSpec.current_example = nil }

      orig_load_path = $LOAD_PATH.dup
      ex.run
      $LOAD_PATH.replace(orig_load_path)
    end
  end

  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234

  # Makes runner specs go forever with certain seeds (e.g. --seed 6871),
  # disabled until the runner will run specs in a subshell. Ref:
  # https://github.com/elia/rspec.tmbundle/commit/92bd792d813f79ffec8484469aa9ce3c7872382b#commitcomment-7325726
  # config.order = 'random'
end

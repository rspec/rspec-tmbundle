# This is based on Florian Weber's TDDMate

ENV['TM_PROJECT_DIRECTORY'] ||= File.dirname(ENV['TM_FILEPATH'])

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/..')

require 'rspec/mate/runner'
require 'rspec/mate/switch_command'

def gemfile?
  # Just `Gemfile` isn't enough: We need `Gemfile.lock` to be able to extract the exact version of RSpec.
  File.exist?(File.join(ENV['TM_PROJECT_DIRECTORY'], 'Gemfile.lock'))
end

def use_binstub?
  File.exist?(File.join(ENV['TM_PROJECT_DIRECTORY'], 'bin', 'rspec'))
end


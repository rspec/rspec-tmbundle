# This is based on Florian Weber's TDDMate

ENV['TM_PROJECT_DIRECTORY'] ||= File.dirname(ENV['TM_FILEPATH'])

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/..')

require 'rspec/mate/runner'
require 'rspec/mate/switch_command'

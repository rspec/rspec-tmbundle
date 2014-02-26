require 'cgi'
require 'rspec/core/formatters/html_formatter'
require "rspec/core/formatters/text_mate_formatter"

module RSpec
  module Mate
    module Formatters
      class TextMateFormatter_2_14 < RSpec::Core::Formatters::TextMateFormatter
        def initialize(output)
          super
          @printer = HtmlPrinterWithNoBacktraceEscape.new(output)
        end
        
        class HtmlPrinterWithNoBacktraceEscape < RSpec::Core::Formatters::HtmlPrinter
          def print_example_failed(pending_fixed, description, run_time, failure_id, exception, extra_content, escape_backtrace = false)
            # Call implementation from superclass, but ignore `escape_backtrace` and always pass `false` instead.
            super(pending_fixed, description, run_time, failure_id, exception, extra_content, false)
          end
        end
      end
    end
  end
end

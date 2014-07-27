if defined?(RSpec)
  bundle_patterns = [%r{/RSpec\.tmbundle/}, %r{^/tmp/textmate-command}]
  if RSpec.configuration.respond_to?(:backtrace_clean_patterns)
    RSpec.configuration.backtrace_clean_patterns += bundle_patterns
  elsif RSpec.configuration.respond_to?(:backtrace_exclusion_patterns)
    RSpec.configuration.backtrace_exclusion_patterns += bundle_patterns
  end
end

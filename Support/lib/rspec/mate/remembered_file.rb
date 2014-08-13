module RSpec
  module Mate
    module RememberedFile
      extend self

      def load
        File.read(cache_path).strip if File.exist?(cache_path)
      end

      def save(path)
        File.open(cache_path, 'w') {|f| f << path}
      end

      def clear
        File.unlink(cache_path) if File.exist?(cache_path)
      end

      def cache_path
        "/tmp/textmate_rspec_last_remembered_file_cache.txt"
      end
    end
  end
end

require "set"

module RSpec
  module Mate
    class GutterMarks
      MARK = "warning"
      SpecError = Struct.new(:line, :message)

      attr_reader :errors_by_path

      def initialize(examples)
        extract_data_from(examples)
      end

      def set_marks
        Dir.chdir(ENV['TM_PROJECT_DIRECTORY'] || ENV['TM_DIRECTORY']) do # Paths are relative to project directory
          errors_by_path.each do |path, errors|
            clear_marks_for(path)
            errors.each do |error|
              set_mark_for(path, error.line, error.message)
            end
          end
        end
      end

      private

      def clear_marks_for(path)
        run_mate("--clear-mark=#{MARK}", path)
      end

      def set_mark_for(path, line, message)
        message = message.strip.gsub("\n", "\r")
        run_mate("--set-mark=#{MARK}:#{message}", "--line=#{line}", path)
      end

      def run_mate(*args)
        system(ENV["TM_MATE"], *args)
      end

      def extract_data_from(examples)
        @errors_by_path = {}
        examples.each do |example|
          @errors_by_path[example.file_path] ||= []
          if example.execution_result.status == :failed && example.location =~ /:(\d+)$/
            line = $1
            message = example.exception ? example.exception.message : "(no exception message)"
            @errors_by_path[example.file_path] << SpecError.new(line, message)
          end
        end
      end
    end
  end
end
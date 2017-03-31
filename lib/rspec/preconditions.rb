require 'rspec/preconditions/version'
require 'rspec/core'

module RSpec
  module Preconditions
    module ClassMethods
      def preconditions(&block)
        before(:each) do |current_example|
          begin
            # Run the block in the context of the current_example.
            # This doesn't run the current_example.
            RSpec::Core::Hooks::BeforeHook.new(block).run(current_example)
          rescue RSpec::Expectations::ExpectationNotMetError, StandardError
            mark_remaining_examples_pending(current_example)
            raise
          end
        end
      end
    end

    def mark_remaining_examples_pending(current_example)
      self.class.descendant_filtered_examples.each do |example|
        next if example == current_example
        already_ran = !example.execution_result.status.nil?
        next if already_ran
        RSpec::Core::Pending.mark_pending!(example, true)
      end
    end
  end

  configure do |config|
    config.extend Preconditions::ClassMethods
    config.include Preconditions
  end
end

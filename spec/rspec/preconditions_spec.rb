require 'rspec/preconditions'

FAILED_PRECONDITION_MESSAGE =
  'When the first example fails, the second one should be skipped!'.freeze

RSpec.shared_context :example_group_with_preconditions do
  let(:example_group) do
    RSpec.describe RSpec::Preconditions do
      shared_context :two_tests do
        example('runs the first example') {}

        example('skips the second example') {}
      end

      preconditions { precondition! }

      context 'when the precondition raises an error' do
        def precondition!
          raise FAILED_PRECONDITION_MESSAGE
        end

        include_context :two_tests
      end

      context 'when the precondition does not meet an expectation' do
        def precondition!
          expect(true).to be false
        end

        include_context :two_tests
      end

      context 'when the precondition succeeds' do
        def precondition!; end

        include_context :two_tests
      end
    end
  end
end

RSpec.shared_examples_for :marks_all_other_examples_pending do
  let(:failed_example) do
    subject.examples.find do |e|
      :failed == e.execution_result.status
    end
  end

  let(:examples_expected_to_be_pending) do
    subject.examples - [failed_example]
  end

  preconditions do
    expect(failed_example).not_to be_nil
    expect(examples_expected_to_be_pending.length).to eq 1
  end

  it 'skips the examples in the same group as the one that failed' do
    examples_expected_to_be_pending.each do |e|
      expect(e.execution_result.status).to eq(:pending)
      expect(e.execution_result.pending_exception).to be_a expected_error
      expect(e.execution_result.pending_exception.message)
        .to eq expected_error_message
    end
  end
end

RSpec.describe RSpec::Preconditions do
  include_context :example_group_with_preconditions

  before(:each) { example_group.run }

  context 'the example group where an error was raised' do
    it_behaves_like :marks_all_other_examples_pending do
      subject { example_group::WhenThePreconditionRaisesAnError }
      let(:expected_error) { RuntimeError }
      let(:expected_error_message) { FAILED_PRECONDITION_MESSAGE }
    end
  end

  it 'does not skip the examples in a group where there were no failures' do
    examples = example_group::WhenThePreconditionSucceeds.examples
    expect(examples.length).to eq 2
    examples.each do |e|
      expect(e.execution_result.status).to eq(:passed)
    end
  end

  context 'the example group where an expectation was not met' do
    it_behaves_like :marks_all_other_examples_pending do
      subject { example_group::WhenThePreconditionDoesNotMeetAnExpectation }
      let(:expected_error) { RSpec::Expectations::ExpectationNotMetError }
      let(:expected_error_message) { "\nexpected false\n     got true\n" }
    end
  end
end

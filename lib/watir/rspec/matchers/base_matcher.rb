require "timeout"

module Watir
  class RSpec
    module Matchers
      class BaseMatcher < ::RSpec::Matchers::BuiltIn::Be
        def initialize(predicate)
          @predicate = predicate
        end

        def matches?(target)
          @target = target

          @seconds ?
            !Timeout.timeout(@seconds) { sleep 0.1 until target.send(@predicate) } :
            target.send(@predicate)
        rescue TimeoutError
          false
        end

        def does_not_match?(target)
          @target = target

          @seconds ?
            !Timeout.timeout(@seconds) { sleep 0.1 while target.send(@predicate) } :
            !target.send(@predicate)
        rescue TimeoutError
          false
        end

        def failure_message_for_should
          "expected #{@target.inspect} to be #{@predicate.to_s[0..-2]}#{timeout_to_s}"
        end

        def failure_message_for_should_not
          "expected #{@target.inspect} not to be #{@predicate.to_s[0..-2]}#{timeout_to_s}"
        end

        def within(seconds)
          @seconds = seconds
          self
        end

        private

        def timeout_to_s
          @seconds ? " within #{@seconds} second(s) " : " "
        end
      end
    end
  end
end

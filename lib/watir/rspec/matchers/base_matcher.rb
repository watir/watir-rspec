require "timeout"

module Watir
  class RSpec
    module Matchers
      # @private
      class BaseMatcher < ::RSpec::Matchers::BuiltIn::Be
        def initialize(predicate)
          @predicate = predicate
        end

        def matches?(target)
          @target = target

          if @within_seconds
            match_with_timeout(@within_seconds, true) { target.send @predicate }
          elsif @during_seconds
            match_with_timeout(@during_seconds, false) { !target.send @predicate }
          else
            target.send(@predicate)
          end
        end

        def does_not_match?(target)
          @target = target

          if @within_seconds
            match_with_timeout(@within_seconds, true) { !target.send @predicate }
          elsif @during_seconds
            match_with_timeout(@during_seconds, false) { target.send @predicate }
          else
            !target.send(@predicate)
          end
        end

        def failure_message_for_should
          "expected #{@target.inspect} to #{be_prefix}#{@predicate.to_s[0..-2]}#{timeout_to_s}"
        end

        def failure_message_for_should_not
          "expected #{@target.inspect} not to #{be_prefix}#{@predicate.to_s[0..-2]}#{timeout_to_s}"
        end

        def within(seconds)
          @within_seconds = seconds
          self
        end

        def during(seconds)
          @during_seconds = seconds
          self
        end

        private

        def match_with_timeout(seconds, expected_result)
          Timeout.timeout(seconds) { sleep 0.1 until (yield rescue false); expected_result } rescue !expected_result
        end

        def be_prefix
          @predicate.to_s[0..-2] == "exist" ? "" : "be "
        end

        def timeout_to_s
          if @within_seconds 
            " within #{@within_seconds} second(s) "
          elsif @during_seconds
            " during #{@during_seconds} second(s) "
          else
            " "
          end
        end
      end
    end
  end
end

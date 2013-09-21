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

          if @within_seconds
            !Timeout.timeout(@within_seconds) { sleep 0.1 until (target.send(@predicate) rescue false) } rescue false
          elsif @during_seconds
            Timeout.timeout(@during_seconds) { sleep 0.1 while (target.send(@predicate) rescue true) } rescue true
          else
            target.send(@predicate)
          end
        end

        def does_not_match?(target)
          @target = target

          if @within_seconds
            !Timeout.timeout(@within_seconds) { sleep 0.1 while (target.send(@predicate) rescue true) } rescue false
          elsif @during_seconds
            Timeout.timeout(@during_seconds) { sleep 0.1 until (target.send(@predicate) rescue false) } rescue true
          else
            !target.send(@predicate)
          end
        end

        def failure_message_for_should
          "expected #{@target.inspect} to be #{@predicate.to_s[0..-2]}#{timeout_to_s}"
        end

        def failure_message_for_should_not
          "expected #{@target.inspect} not to be #{@predicate.to_s[0..-2]}#{timeout_to_s}"
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

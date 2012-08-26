require 'rspec'
require File.expand_path("rspec/helper", File.dirname(__FILE__))
require File.expand_path("rspec/html_formatter", File.dirname(__FILE__))

module Watir
  # add #within(timeout) and #during(timeout) methods for every matcher for allowing to wait until some condition is met.
  #     div.click
  #     another_div.should be_present.within(5)
  #
  #     expect {
  #       div.click
  #     }.to change {another_div.text}.from("before").to("after").within(5)
  #
  #     expect {
  #       div.click
  #     }.to make {another_div.present?}.within(5)
  #
  #     expect {
  #       div.click
  #     }.to change {another_div.text}.soon
  #
  class RSpec
    class << self
      def bootstrap const
        const.class_eval do

          inst_methods = instance_methods.map &:to_sym

          if !(inst_methods.include?(:__matches?) || inst_methods.include?(:__does_not_match?)) && 
            (inst_methods.include?(:matches?) || inst_methods.include?(:does_not_match?))

            def within(timeout)
              @within_timeout = timeout
              self
            end

            def during(timeout)
              @during_timeout = timeout
              self
            end

            def soon 
              within(30)
            end      

            def seconds
              # for syntactic sugar
              self
            end

            alias_method :second, :seconds

            def minutes
              @within_timeout *= 60 if @within_timeout
              @during_timeout *= 60 if @during_timeout
              self
            end

            alias_method :minute, :minutes
          end

          if inst_methods.include? :matches?
            alias_method :__matches?, :matches? 

            def matches?(actual)
              match_with_wait {__matches?(actual)}
            end
          end

          if inst_methods.include? :does_not_match?
            alias_method :__does_not_match?, :does_not_match?

            def does_not_match?(actual)
              match_with_wait {__does_not_match?(actual)}
            end
          elsif inst_methods.include? :matches?
            def does_not_match?(actual)
              match_with_wait {!__matches?(actual)}
            end
          end

          private

          def match_with_wait
            if @within_timeout
              timeout = @within_timeout; @within_timeout = nil
              Watir::Wait.until(timeout) {yield} rescue false
            elsif @during_timeout
              timeout = @during_timeout; @during_timeout = nil
              Watir::Wait.while(timeout) {yield} rescue true        
            else
              yield
            end
          end
        end
      end
    end

    # patch for #within(timeout) method
    module ::RSpec::Matchers
      class BuiltIn::Change
        def matches?(event_proc)
          raise_block_syntax_error if block_given?

          # to make #change work with #in(timeout) method
          unless defined? @actual_before
            @actual_before = evaluate_value_proc
            event_proc.call
          end
          @actual_after = evaluate_value_proc

          (!change_expected? || changed?) && matches_before? && matches_after? && matches_expected_delta? && matches_min? && matches_max?
        end
      end

      alias_method :make, :change
    end

  end
end

matchers = RSpec::Matchers::BuiltIn.constants.map(&:to_sym)
matchers.delete :BaseMatcher
matchers.each do |const|
  Watir::RSpec.bootstrap RSpec::Matchers::BuiltIn.const_get const
end

Watir::RSpec.bootstrap RSpec::Matchers::DSL::Matcher

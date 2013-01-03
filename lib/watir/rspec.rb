require 'rspec'
require File.expand_path("rspec/helper", File.dirname(__FILE__))
require File.expand_path("rspec/html_formatter", File.dirname(__FILE__))

if defined? ActiveRecord
  require File.expand_path("rspec/active_record_shared_connection", File.dirname(__FILE__))
end

module Watir
  class RSpec
    class << self
      # Add #within(timeout) and #during(timeout) methods for every matcher for allowing to wait until some condition is met.
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
      # @private
      def add_within_and_during_to_matcher const
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

      # Generate unique file path for the current spec. If the file
      # will be created during that spec and spec fails then it will be
      # shown automatically in the html report.
      #
      # @param [String] File name to be used for file.
      #   Will be used as a part of the complete name.
      # @return [String] Absolute path for the unique file name.
      # @raise [RuntimeError] when {Watir::RSpec::HtmlFormatter} is not in use.
      def file_path(file_name, description=nil)
        formatter.file_path(file_name, description=nil)
      end

      private

      def formatter
        @formatter ||= begin
                         formatter = ::RSpec.configuration.formatters.find {|f| f.kind_of? Watir::RSpec::HtmlFormatter}
                         unless formatter
                           raise <<-EOF
  Watir::RSpec::HtmlFormatter is not set as a RSpec formatter.

  You need to add it into your spec_helper.rb file like this:
    RSpec.configure do |config|
      config.add_formatter('documentation')
      config.add_formatter(Watir::RSpec::HtmlFormatter)
    end
                           EOF
                         end
                         formatter
                       end
      end


    end

  end
end

# patch for #within(timeout) method
# @private
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

matchers = RSpec::Matchers::BuiltIn.constants.map(&:to_sym)
matchers.delete :BaseMatcher
matchers.each do |const|
  Watir::RSpec.add_within_and_during_to_matcher RSpec::Matchers::BuiltIn.const_get const
end

Watir::RSpec.add_within_and_during_to_matcher RSpec::Matchers::DSL::Matcher

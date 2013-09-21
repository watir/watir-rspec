module Watir
  class RSpec
    # All matchers defined in here have the ability to be used for asynchronous
    # testing.
    #
    # There is #within matcher which means that the expected result should happen
    # within the specified time period.
    #
    # There also exists less used #during matcher which means that the expected
    # result should be true for the whole specified time period.
    #
    # @example Wait for 2 seconds until element is present (element exists and is visible)
    #   text_field.should be_present.within(2)
    #   
    # @example Wait for 2 seconds until element is visible
    #   text_field.should be_visible.within(2)
    #
    # @example Wait for 2 seconds until element exists
    #   text_field.should exist.within(2)
    #
    # @example Make sure that container is visible for the whole time during 2 seconds
    #   button.click
    #   div.should be_visible.during(2)
    module Matchers
      def be_present
        BaseMatcher.new :present?
      end

      def be_visible
        BaseMatcher.new :visible?
      end      

      def exist
        BaseMatcher.new :exist?
      end
    end
  end
end

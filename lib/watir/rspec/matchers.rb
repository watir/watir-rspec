module Watir
  class RSpec
    # All matchers defined in here have the ability to be used for asynchronous
    # testing.
    #
    # #within matcher means that the expected result should happen
    # within the specified time period.
    #
    # Also less used #during matcher which means that the expected
    # result should be true for the whole specified time period.
    #
    # @example Wait for 2 seconds until element is present (element exists and is visible)
    #   expect(text_field).to be_present.within(2)
    #   
    # @example Wait for 2 seconds until element is visible
    #   expect(text_field).to be_visible.within(2)
    #
    # @example Wait for 2 seconds until element exists
    #   expect(text_field).to exist.within(2)
    #
    # @example Verify that container is visible for the whole time during 2 seconds
    #   button.click
    #   expect(text_field).to be_visible.during(2)
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

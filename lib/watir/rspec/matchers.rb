module Watir
  class RSpec
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

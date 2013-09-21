module Watir
  class RSpec
    module Matchers
      def be_present
        BaseMatcher.new :present?
      end
    end
  end
end

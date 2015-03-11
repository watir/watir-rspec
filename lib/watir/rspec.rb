module Watir
  class RSpec
    class << self
      # Generate unique file path for the current spec. If the file
      # will be created during that spec and spec fails then it will be
      # shown automatically in the html report.
      #
      # @param [String] file_name File name to be used for file.
      #   Will be used as a part of the complete name.
      # @return [String] Absolute path for the unique file name.
      # @raise [RuntimeError] when {Watir::RSpec::HtmlFormatter} is not in use.
      def file_path(file_name, description=nil)
        formatter.file_path(file_name, description)
      end

      # @private
      def active_record_loaded?
        defined? ActiveRecord::Base
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

require "rspec"
require "watir"

require File.expand_path("rspec/active_record_shared_connection", File.dirname(__FILE__))
require File.expand_path("rspec/helper", File.dirname(__FILE__))
require File.expand_path("rspec/matchers/base_matcher", File.dirname(__FILE__))
require File.expand_path("rspec/matchers", File.dirname(__FILE__))
require File.expand_path("rspec/html_formatter", File.dirname(__FILE__))


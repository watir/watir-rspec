require "optparse"

module Watir
  class RSpec
    # @private
    class CLI
      class << self
        def execute
          @options = {}
          parser = OptionParser.new do |opts|
            opts.banner = "Install watir-rspec configuration into spec_helper file.

Usage: watir-rspec [options] install"

            opts.on("-r", "--[no-]rails", "Force to install watir-rspec for Rails application if the detection fails") do |v|
              @options[:rails] = v
            end

            opts.on("-f", "--force", "Force to install watir-rspec even if it seems to be installed already") do |v|
              @options[:force] = v
            end
          end

          parser.parse!

          if ARGV.size != 1 || ARGV.first != "install"
            puts parser
            exit
          end

          if @options[:force] || !already_installed?
            install 
          else
            puts "watir-rspec is already installed into #{spec_helper}... skipping."
            exit
          end
        end

        private

        def install
          puts "Rails application #{using_rails? ? "detected" : "not detected"}.
Installing watir-rspec configuration into #{spec_helper}."

          File.open(spec_helper, "a") do |file|
            file.puts %Q[
# Configuration for watir-rspec
require "watir/rspec"

RSpec.configure do |config|
  # Use Watir::RSpec::HtmlFormatter to get links to the screenshots, html and
  # all other files created during the failing examples.
  config.add_formatter(:progress) if config.formatters.empty?
  config.add_formatter(Watir::RSpec::HtmlFormatter)

  # Open up the browser for each example.
  config.before :all#{rails_filter} do
    @browser = Watir::Browser.new
  end

  # Close that browser after each example.
  config.after :all#{rails_filter} do
    @browser.close if @browser
  end

  # Include RSpec::Helper into each of your example group for making it possible to
  # write in your examples instead of:
  #   @browser.goto "localhost"
  #   @browser.text_field(:name => "first_name").set "Bob"
  #
  # like this:
  #   goto "localhost"
  #   text_field(:name => "first_name").set "Bob"
  #
  # This needs that you've used @browser as an instance variable name in
  # before :all block.
  config.include Watir::RSpec::Helper#{rails_filter}

  # Include RSpec::Matchers into each of your example group for making it possible to
  # use #within with some of RSpec matchers for easier asynchronous testing:
  #   @browser.text_field(:name => "first_name").should exist.within(2)
  #   @browser.text_field(:name => "first_name").should be_present.within(2)
  #   @browser.text_field(:name => "first_name").should be_visible.within(2)
  #
  # You can also use #during to test if something stays the same during the specified period:
  #   @browser.text_field(:name => "first_name").should exist.during(2)
  config.include Watir::RSpec::Matchers#{rails_filter}
end
  ]
          end
        end

        def already_installed?
          File.exist?(spec_helper) && File.read(spec_helper) =~ /Watir::RSpec/
        end

        def spec_directory
          specs = File.expand_path("spec")

          unless File.directory? specs
            puts %Q[#{specs} directory not found.
Make sure you run the watir-rspec command within your projects' directory.]

            exit 1
          end

          specs
        end

        def spec_helper
          File.join(spec_directory, "spec_helper.rb")
        end

        def rails_filter
          ", :type => :request" if using_rails?
        end

        def using_rails?
          return @options[:rails] if @options.has_key? :rails

          @using_rails ||= begin
                             File.exists?("Gemfile.lock") && File.read("Gemfile.lock") =~ /rspec-rails/ ||
                               File.exists?("Gemfile") && File.read("Gemfile") =~ /rspec-rails/
                           end
        end
      end
    end
  end
end

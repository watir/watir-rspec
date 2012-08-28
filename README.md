# Watir::RSpec

Use Watir with RSpec with ease.

## Installation

Add these lines to your application's Gemfile:

    group :test do
      gem 'watir-rspec'
    end

And add these lines to your spec\_helper.rb file:

    RSpec.configure do |config|
      # Add Watir::RSpec::HtmlFormatter to get links to the screenshots, html and
      # all other files created during the failing examples.
      config.add_formatter('documentation')
      config.add_formatter(Watir::RSpec::HtmlFormatter)

      # Open up the browser for each example.
      config.before :all do
        @browser = Watir::Browser.new
      end

      # Close that browser after each example.
      config.after :all do
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
      config.include Watir::RSpec::Helper
    end


When using Rails and writing specs to requests directory, add an additional filter for RSpec:

    config.before :all, :type => :request do
      @browser = Watir::Browser.new :chrome
    end

    config.after :all, :type => :request do
      @browser.close if @browser
    end

    config.include Watir::RSpec::Helper, :type => :request

## Usage

Just use the browser in your examples. If you haven't included
Watir::RSpec::Helper, then you need to use the @browser instance variable when
calling Watir::Browser methods, otherwise you may omit it.

When creating/downloading/uploading files in your examples and using
Watir::RSpec::HtmlFormatter then you can generate links automatically to these files when example
fails. To do that you need to use Watir::RSpec.file\_path method for generating
unique file name:

    uploaded_file_path = Watir::RSpec.file_path("uploaded.txt")
    File.open(uploaded_file_path, "w") {|file| file.write "Generated File Input"}

If you're using Rails, then you also need to install [watir-rails](https://github.com/watir/watir-rails) gem.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

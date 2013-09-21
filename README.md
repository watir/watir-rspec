# Watir::RSpec
[![Gem Version](https://badge.fury.io/rb/test-page.png)](http://badge.fury.io/rb/watir-rspec)
[![Build Status](https://api.travis-ci.org/watir/watir-rspec.png)](http://travis-ci.org/watir/watir-rspec)
[![Coverage](https://coveralls.io/repos/watir/watir-rspec/badge.png?branch=master)](https://coveralls.io/r/watir/watir-rspec)

Use [Watir](http://watir.com) with [RSpec](http://rspec.info) with ease.

* No need to use the `@browser` or `$browser` variables when executing browser methods.
* No need to open the browser in your each test manually.
* Easily test for asynchronous events by using `#within` matchers.
* Easily test that something stays the same within some period by using `#during` matchers.
* Get nice html reports with links to automatic screenshots and other files generated during test.

## Installation

Add these lines to your application's Gemfile:

````ruby
group :test do
  gem 'watir-rspec'
end
````

Or install it yourself as:

    gem install watir-rspec

And add these lines to your `spec_helper.rb` file:

````ruby
require "watir/rspec"

RSpec.configure do |config|
  # Add Watir::RSpec::HtmlFormatter to get links to the screenshots, html and
  # all other files created during the failing examples.
  config.add_formatter("documentation")
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
  
  # Include RSpec::Matchers into each of your example group for making it possible to
  # use #within with some of RSpec matchers for easier asynchronous testing:
  #   @browser.text_field(:name => "first_name").should exist.within(2)
  #   @browser.text_field(:name => "first_name").should be_present.within(2)
  #   @browser.text_field(:name => "first_name").should be_visible.within(2)
  #
  # You can also use #during to test if something stays the same during the specified period:
  #   @browser.text_field(:name => "first_name").should exist.during(2)
  config.include Watir::RSpec::Matchers
end
````


When using [rspec-rails](https://github.com/rspec/rspec-rails) and writing specs to requests directory, add an additional filter for RSpec:

````ruby
config.before :all, :type => :request do
  @browser = Watir::Browser.new :chrome
end

config.after :all, :type => :request do
  @browser.close if @browser
end

config.include Watir::RSpec::Helper, :type => :request
config.include Watir::RSpec::Matchers, :type => :request
````

## Usage

````ruby
describe "Google" do
  before { goto "http://google.com" }
  
  it "has search box" do
   text_field(:name => "q").should be_present
  end
  
  it "allows to search" do
    text_field(:name => "q").set "watir"
    results = div(:id => "ires")
    results.should be_present.within(2)
    results.lis(:class => "g").map(&:text).should be_any { |text| text =~ /watir/ }
    results.should be_present.during(1)
  end
end
````

### Files created during specs

You can use `Watir::RSpec.file_path` to have links automatically in the html report
to the files created during tests.

```ruby
uploaded_file_path = Watir::RSpec.file_path("uploaded.txt")
File.open(uploaded_file_path, "w") {|file| file.write "Generated File Input"}
file_field(:name => "upload-file").set uploaded_file_path
```

### Rails

Use [watir-rails](https://github.com/watir/watir-rails) gem together with `watir-rspec` to achieve maximum satisfaction.

## License

Copyright (c) Jarmo Pertman (jarmo.p@gmail.com). See LICENSE for details.

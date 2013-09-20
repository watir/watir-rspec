# Watir::RSpec
[![Gem Version](https://badge.fury.io/rb/test-page.png)](http://badge.fury.io/rb/watir-rspec)
[![Build Status](https://api.travis-ci.org/watir/watir-rspec.png)](http://travis-ci.org/watir/watir-rspec)

Use [Watir](http://watir.com) with [RSpec](http://rspec.info) with ease.

## Installation

Add these lines to your application's Gemfile:

````ruby
group :test do
  gem 'watir-rspec'
end
````

And add these lines to your spec\_helper.rb file:

````ruby
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
````


When using Rails and writing specs to requests directory, add an additional filter for RSpec:

````ruby
config.before :all, :type => :request do
  @browser = Watir::Browser.new :chrome
end

config.after :all, :type => :request do
  @browser.close if @browser
end

config.include Watir::RSpec::Helper, :type => :request
````

## Usage

### Executing browser methods

If you did include ````Watir::Rspec::Helper```` then it is possible to write code like this in your specs:

````ruby
text_field(:id => "something").set "foo"
````

If you did not include ````Watir::RSpec::Helper```` then you have to use browser variable:

````ruby
@browser.text_field(:id => "something").set "foo"
````

### Testing asynchronous functionality

````Watir::RSpec```` adds convenience methods ````#within```` and ````#during```` to all of the RSpec matchers,
which help to write better and more beautiful test code.

Let us pretend that the following div will appear dynamically after some Ajax request.

We can use the standard way:

````ruby
Watir::Wait.until(5) { div(:id => "something").present? }
````

Or we can use ````#within```` method:

````ruby
div(:id => "something").should be_present.within(5)
````

````#during```` is the opposite of ````#within```` - it means that during the specified time something should be true/false.

PS! There is one caveat when using ````#within```` or ````#during```` - it cannot be used in every possible situation.

For example, this won't work as expected:

````ruby
div(:id => "something").text.should eq("foo").within(5)
````

The reason is that RSpec will check if value of ````#text```` will change to ````"foo"````, but it is just some ````String````,
which won't change ever. The rule of thumb is that ````#should```` should be always called on an instance of
the ````Element```` and ````#within/#duration```` on the matcher for that ````Element```` (e.g. ````be_present````, ````be_visible````, ````exist```` etc.).

### Files created during specs

When creating/downloading/uploading files in your examples and using
````Watir::RSpec::HtmlFormatter```` then you can generate links automatically to these files when example
fails. To do that you need to use ````Watir::RSpec.file_path```` method for generating
unique file name:

````ruby
uploaded_file_path = Watir::RSpec.file_path("uploaded.txt")
File.open(uploaded_file_path, "w") {|file| file.write "Generated File Input"}
````

### Rails support

If you're using Rails, then you also need to install [watir-rails](https://github.com/watir/watir-rails) gem.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) Jarmo Pertman (jarmo.p@gmail.com). See LICENSE for details.

# Watir::RSpec
[![Gem Version](https://badge.fury.io/rb/watir-rspec.png)](http://badge.fury.io/rb/watir-rspec)
[![Build Status](https://api.travis-ci.org/watir/watir-rspec.png)](http://travis-ci.org/watir/watir-rspec)
[![Coverage](https://coveralls.io/repos/watir/watir-rspec/badge.png?branch=master)](https://coveralls.io/r/watir/watir-rspec)

Use [Watir](http://watir.com) with [RSpec](http://rspec.info) with ease.

* No need to use the `@browser` or `$browser` variables when executing browser methods.
* No need to open the browser in your each test manually.
* Easily test for asynchronous events by using `#within` matchers.
* Easily test that something stays the same within some period by using `#during` matchers.
* Get nice html reports with links to html, screenshots and other files generated during test.

## Installation

Add these lines to your application's Gemfile:

````ruby
group :test do
  gem "watir-rspec"
end
````

Or install it manually as:

    gem install watir-rspec

And execute the following command to add `watir-rspec` configuration into your `spec_helper`:

    watir-rspec install

## Usage

Check out the [documentation](http://rubydoc.info/gems/watir-rspec/frames) and the straight-forward fully working examples below.

````ruby
require "spec_helper"

describe "Google" do
  before { goto "http://google.com" }
  
  it "has search box" do
    text_field(:name => "q").should be_present
  end
  
  it "allows to search" do
    text_field(:name => "q").set "watir"
    button(:id => "gbqfb").click
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

You need to use [rspec-rails](https://github.com/rspec/rspec-rails) and [watir-rails](https://github.com/watir/watir-rails) gems together with `watir-rspec` to achieve maximum satisfaction.

## License

Copyright (c) [Jarmo Pertman](https://github.com/jarmo) (jarmo.p@gmail.com). See LICENSE for details.

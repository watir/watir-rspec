require "simplecov"
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start

RSpec.configure do |c|
  c.color = true
  c.order = :random
end

# Make sure constants are defined
module ::ActiveRecord
  class Base
  end
end

require "watir/rspec"

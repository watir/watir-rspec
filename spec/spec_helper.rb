RSpec.configure do |c|
  c.color = true
end

# Make sure constants are defined
module ActiveRecord
  class Base
  end
end

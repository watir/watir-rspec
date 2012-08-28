RSpec.configuration.before(:suite) do
  # Allow RSpec specs to use transactional fixtures when using Watir. 
  #
  # Tip from http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
  class ::ActiveRecord::Base
    mattr_accessor :shared_connection
    @@shared_connection = nil

    def self.connection
      @@shared_connection || retrieve_connection
    end
  end

  # Forces all threads to share the same connection. 
  ::ActiveRecord::Base.shared_connection = ::ActiveRecord::Base.connection
end

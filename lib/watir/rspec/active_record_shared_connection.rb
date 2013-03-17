require "thread"

RSpec.configuration.before(:suite) do
  # Allow RSpec specs to use transactional fixtures when using Watir. 
  #
  # Tip from http://blog.plataformatec.com.br/2011/12/three-tips-to-improve-the-performance-of-your-test-suite/
  class ::ActiveRecord::Base
    @@shared_connection_semaphore = Mutex.new
    @@shared_connection = nil

    def self.connection
      @@shared_connection_semaphore.synchronize do
        @@shared_connection ||= retrieve_connection
      end
    end
  end

end

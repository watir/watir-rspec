module Watir
  class RSpec
    module Helper
      def method_missing name, *args #:nodoc:
        if @browser.respond_to?(name)
          Helper.module_eval %Q[
            def #{name}(*args)
              @browser.send(:#{name}, *args) {yield}
            end
          ]
          self.send(name, *args) {yield}
        else
          super
        end
      end

      # make sure that using method 'p' will be invoked on browser
      # and not Kernel
      # use Kernel.p if you need to dump some variable 
      def p *args #:nodoc:
        @browser.p *args
      end
    end
  end
end

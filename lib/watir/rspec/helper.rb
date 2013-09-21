module Watir
  class RSpec
    module Helper
      extend Forwardable

      # @return [Watir::Browser] a current browser instance if it is initialized with 
      #   @browser or $browser variable name.
      def browser
        @browser || $browser
      end

      # Will dispatch all missing methods to the {#browser} instance.
      # @example Makes it possible to use Watir::Browser methods without specifying the browser instance in the specs like this:
      #  it "should do something" do
      #    # notice that we're calling Watir::Browser#text_field here directly
      #    text_field(:id => "foo").should be_present
      #  end
      def method_missing(name, *args)
        if browser.respond_to?(name)
          Helper.module_eval %Q[
            def #{name}(*args)
              browser.send(:#{name}, *args) {yield}
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
      def_delegators :browser, :p
    end
  end
end

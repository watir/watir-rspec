require "forwardable"

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
      #  it "text field is present" do
      #    # notice that we're calling Watir::Browser#text_field here directly
      #    expect(text_field(id: "foo")).to be_present
      #  end
      def method_missing(name, *args, &block)
        if browser.respond_to?(name)
          Helper.module_eval %Q[
            def #{name}(*args, &block)
              if block
                browser.send(:#{name}, *args, &block)
              else
                browser.send(:#{name}, *args)
              end
            end
          ]

          if block
            self.send(name, *args, &block)
          else
            self.send(name, *args)
          end
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

require "spec_helper"

describe Watir::RSpec::Helper do
  before { self.send :extend, described_class }
  after { $browser = @browser = nil }

  context "#browser" do
    it "delegates to @browser if exists" do
      @browser = :browser
      browser.should == @browser
    end

    it "delegates to @browser if @browser exists even if $browser exists" do
      @browser = :browser
      $browser = :global_browser
      browser.should == @browser
    end

    it "delegates to $browser if @browser does not exist" do
      $browser = :global_browser
      browser.should == $browser
    end
  end

  context "#method_missing" do
    it "redirects missing methods to browser if method exists" do
      @browser = double("browser", coolness_factor: :very)
      coolness_factor.should == :very
    end

    it "raises error when browser does not have method" do
      @browser = double("browser")
      described_class.should_not be_method_defined :not_existing_method

      expect do
        self.not_existing_method
      end.to raise_error(NoMethodError)

      described_class.should_not be_method_defined :not_existing_method
    end

    it "adds browser methods to the helper" do
      @browser = double("browser", method_to_be_defined: :done)
      described_class.should_not be_method_defined :method_to_be_defined
      method_to_be_defined.should == :done
      described_class.should be_method_defined :method_to_be_defined
    end
  end

  it "#p is delegated to the browser" do
    @browser = double("browser", p: "#p")
    described_class.should_not_receive(:method_missing)

    p.should == "#p"
  end
end

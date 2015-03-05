require "spec_helper"

describe Watir::RSpec::Helper do
  before { self.send :extend, described_class }
  after { $browser = @browser = nil }

  context "#browser" do
    it "delegates to @browser if exists" do
      @browser = :browser
      expect(browser).to be @browser
    end

    it "delegates to @browser if @browser exists even if $browser exists" do
      @browser = :browser
      $browser = :global_browser
      expect(browser).to be @browser
    end

    it "delegates to $browser if @browser does not exist" do
      $browser = :global_browser
      expect(browser).to be $browser
    end
  end

  context "#method_missing" do
    it "redirects missing methods to browser if method exists" do
      @browser = double("browser", coolness_factor: :very)
      expect(coolness_factor).to eql :very
    end

    it "raises error when browser does not have method" do
      @browser = double("browser")
      expect(described_class).not_to respond_to :method_to_be_defined

      expect do
        self.method_to_be_defined
      end.to raise_error(NoMethodError)
      expect(described_class).not_to respond_to :method_to_be_defined
    end

    it "adds browser methods to the helper" do
      @browser = double("browser", method_to_be_defined2: :done)

      expect(described_class.instance_methods).not_to include :method_to_be_defined2
      expect(method_to_be_defined2).to eql :done
      expect(described_class.instance_methods).to include :method_to_be_defined2
    end
  end

  it "#p is delegated to the browser" do
    @browser = double("browser", p: "#p")
    expect(described_class).not_to receive(:method_missing)

    expect(p).to eql "#p"
  end
end

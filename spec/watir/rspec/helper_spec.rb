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
      expect(described_class).not_to respond_to :not_existing_method

      expect do
        self.not_existing_method
      end.to raise_error(NoMethodError)
      expect(described_class).not_to respond_to :not_existing_method
    end

    it "adds browser methods to the helper" do
      @browser = double("browser", not_existing_method2: :done)

      expect(described_class.instance_methods).not_to include :not_existing_method2
      # expect(described_class).not_to respond_to :not_existing_method
      expect(not_existing_method2).to eql :done
      expect(described_class.instance_methods).to include :not_existing_method2
      # ---> this one fails for some reason; for now use instance_methods include + used different method name as somehow the previous example fails when running the spec multiple times
      # expect(described_class).to respond_to :not_existing_method
    end
  end

  it "#p is delegated to the browser" do
    @browser = double("browser", p: "#p")
    expect(described_class).not_to receive(:method_missing)

    expect(p).to eql "#p"
  end
end

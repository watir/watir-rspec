require "spec_helper"

describe Watir::RSpec::Matchers do
  before { self.send :extend, described_class }

  it "#be_present" do
    be_present.should == Watir::RSpec::Matchers::BaseMatcher
  end
end

require "spec_helper"

describe Watir::RSpec::Matchers do
  before { self.send :extend, described_class }

  it "#be_present" do
    matcher = be_present
    matcher.should == Watir::RSpec::Matchers::BaseMatcher
    matcher.instance_variable_get(:@predicate).should == :present?
  end

  it "#be_visible" do
    matcher = be_visible
    matcher.should == Watir::RSpec::Matchers::BaseMatcher
    matcher.instance_variable_get(:@predicate).should == :visible?
  end

  it "#exist" do
    matcher = exist
    matcher.should == Watir::RSpec::Matchers::BaseMatcher
    matcher.instance_variable_get(:@predicate).should == :exist?
  end  
end

require "spec_helper"

describe Watir::RSpec::Matchers do
  before { self.send :extend, described_class }

  it "#be_present" do
    matcher = be_present
    expect(matcher).to be_a Watir::RSpec::Matchers::BaseMatcher
    expect(matcher.instance_variable_get(:@predicate)).to eql :present?
  end

  it "#be_visible" do
    matcher = be_visible
    expect(matcher).to be_a Watir::RSpec::Matchers::BaseMatcher
    expect(matcher.instance_variable_get(:@predicate)).to eql  :visible?
  end

  it "#exist" do
    matcher = exist
    expect(matcher).to be_a Watir::RSpec::Matchers::BaseMatcher
    expect(matcher.instance_variable_get(:@predicate)).to eql :exist?
  end  
end

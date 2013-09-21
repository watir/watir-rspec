require "spec_helper"

describe Watir::RSpec::Matchers::BaseMatcher do
  before { self.class.send(:define_method, :be_foo) { described_class.new :foo? } }

  it "#matches?" do
    object = double("element", foo?: true)
    object.should be_foo
  end

  it "#matches? with error" do
    object = double("element", foo?: false)
    expect {
      object.should be_foo
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "#does_not_match?" do
    object = double("element", foo?: false)
    object.should_not be_foo
  end

  it "#does_not_match? with error" do
    object = double("element", foo?: true)
    expect {
      object.should_not be_foo
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  context "#within" do
    it "#matches?" do
      object = double("element")
      @result = false
      object.stub(:foo?) { @result }
      thr = Thread.new { sleep 0.1; @result = true }

      t = Time.now
      object.should be_foo.within(1)
      (Time.now - t).should be >= 0.1
      thr.join
    end

    it "#matches? with error" do
      object = double("element")
      object.stub(:foo?) { false }

      t = Time.now
      expect {
        object.should be_foo.within(0.1)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      (Time.now - t).should be >= 0.1
    end

    it "#does_not_match?" do
      object = double("element")
      @result = true
      object.stub(:foo?) { @result }
      thr = Thread.new { sleep 0.1; @result = false }

      t = Time.now
      object.should_not be_foo.within(1)
      (Time.now - t).should be >= 0.1
      thr.join
    end    

    it "#does_not_match? with error" do
      object = double("element")
      object.stub(:foo?) { true }

      t = Time.now
      expect {
        object.should_not be_foo.within(0.1)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      (Time.now - t).should be >= 0.1
    end
  end
end

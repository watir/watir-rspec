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
    around { |example| should_take_at_least(0.1) { example.run }}

    it "#matches?" do
      object = double("element")
      @result = false
      object.stub(:foo?) { @result }
      thr = Thread.new { sleep 0.1; @result = true }

      object.should be_foo.within(1)
      thr.join
    end

    it "#matches? with timeout error" do
      object = double("element", foo?: false)

      expect {
        object.should be_foo.within(0.1)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it "#matches? with some other error" do
      object = double("element")
      raised = false
      object.stub(:foo?) do
        unless raised
          raised = true
          raise "Some unexpected exception"
        else
          sleep 0.1
          true
        end
      end

      object.should be_foo.within(1)
      raised.should be_true
    end

    it "#does_not_match?" do
      object = double("element")
      @result = true
      object.stub(:foo?) { @result }
      thr = Thread.new { sleep 0.1; @result = false }

      object.should_not be_foo.within(1)
      thr.join
    end    

    it "#does_not_match? with timeout error" do
      object = double("element", foo?: true)

      expect {
        object.should_not be_foo.within(0.1)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it "#does_not_match? with some other error" do
      object = double("element")
      raised = false
      object.stub(:foo?) do
        unless raised
          raised = true
          raise "Some unexpected exception"
        else
          sleep 0.1
          false
        end
      end

      object.should_not be_foo.within(1)
      raised.should be_true
    end
  end

  context "#during" do
    around { |example| should_take_at_least(0.1) { example.run }}

    it "#matches?" do
      object = double("element", foo?: true)

      object.should be_foo.during(0.1)
    end

    it "#matches? with timeout error" do
      object = double("element")
      @result = true
      object.stub(:foo?) { @result }
      thr = Thread.new { sleep 0.1; @result = false }

      expect {
        object.should be_foo.during(1)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      thr.join
    end

    it "#matches? with some other error" do
      object = double("element")
      raised = false
      object.stub(:foo?) do
        unless raised
          raised = true
          raise "Some unexpected exception"
        else
          true
        end
      end

      object.should be_foo.during(0.1)
      raised.should be_true
    end

    it "#does_not_match?" do
      object = double("element", foo?: false)

      object.should_not be_foo.during(0.1)
    end    

    it "#does_not_match? with timeout error" do
      object = double("element")
      @result = false
      object.stub(:foo?) { @result }
      thr = Thread.new { sleep 0.1; @result = true }

      expect {
        object.should_not be_foo.during(1)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      thr.join
    end

    it "#does_not_match? with some other error" do
      object = double("element")
      raised = false
      object.stub(:foo?) do
        unless raised
          raised = true
          raise "Some unexpected exception"
        else
          false
        end
      end

      object.should_not be_foo.during(0.1)
      raised.should be_true
    end    
  end

  def should_take_at_least(seconds)
    t = Time.now
    yield
    (Time.now - t).should be >= seconds
  end
end

require "spec_helper"

describe Watir::RSpec::Matchers::BaseMatcher do
  before { self.class.send(:define_method, :be_foo) { described_class.new :foo? } }

  it "#matches?" do
    object = double("element", foo?: true)
    expect(object).to be_foo
  end

  it "#matches? with error" do
    object = double("element", foo?: false)
    expect {
      expect(object).to be_foo
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "#does_not_match?" do
    object = double("element", foo?: false)
    expect(object).not_to be_foo
  end

  it "#does_not_match? with error" do
    object = double("element", foo?: true)
    expect {
      expect(object).not_to be_foo
    }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  context "#within" do
    around { |example| should_take_at_least(0.1) { example.run }}

    it "#matches?" do
      object = double("element")
      @result = false
      allow(object).to receive (:foo?) { @result }
      thr = Thread.new { sleep 0.1; @result = true }

      expect(object).to be_foo.within(1)
      thr.join
    end

    it "#matches? with timeout error" do
      object = double("element", foo?: false)

      expect {
        expect(object).to be_foo.within(0.1)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it "#matches? with some other error" do
      object = double("element")
      raised = false
      allow(object).to receive (:foo?) do
        unless raised
          raised = true
          raise "Some unexpected exception"
        else
          sleep 0.1
          true
        end
      end

      expect(object).to be_foo.within(1)
      expect(raised).to be true
    end

    it "#does_not_match?" do
      object = double("element")
      @result = true
      allow(object).to receive (:foo?) { @result }
      thr = Thread.new { sleep 0.1; @result = false }

      expect(object).not_to be_foo.within(1)
      thr.join
    end    

    it "#does_not_match? with timeout error" do
      object = double("element", foo?: true)

      expect {
        expect(object).not_to be_foo.within(0.1)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
    end

    it "#does_not_match? with some other error" do
      object = double("element")
      raised = false
      allow(object).to receive (:foo?) do
        unless raised
          raised = true
          raise "Some unexpected exception"
        else
          sleep 0.1
          false
        end
      end

      expect(object).not_to be_foo.within(1)
      expect(raised).to be true
    end
  end

  context "#during" do
    around { |example| should_take_at_least(0.1) { example.run }}

    it "#matches?" do
      object = double("element", foo?: true)

      expect(object).to be_foo.during(0.1)
    end

    it "#matches? with timeout error" do
      object = double("element")
      @result = true
      allow(object).to receive (:foo?) { @result }
      thr = Thread.new { sleep 0.1; @result = false }

      expect {
        expect(object).to be_foo.during(1)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      thr.join
    end

    it "#matches? with some other error" do
      object = double("element")
      raised = false
      allow(object).to receive (:foo?) do
        unless raised
          raised = true
          raise "Some unexpected exception"
        else
          true
        end
      end

      expect(object).to be_foo.during(0.1)
      expect(raised).to be true
    end

    it "#does_not_match?" do
      object = double("element", foo?: false)

      expect(object).not_to be_foo.during(0.1)
    end    

    it "#does_not_match? with timeout error" do
      object = double("element")
      @result = false
      allow(object).to receive (:foo?) { @result }
      thr = Thread.new { sleep 0.1; @result = true }

      expect {
        expect(object).not_to be_foo.during(1)
      }.to raise_error(RSpec::Expectations::ExpectationNotMetError)
      thr.join
    end

    it "#does_not_match? with some other error" do
      object = double("element")
      raised = false
      allow(object).to receive (:foo?) do
        unless raised
          raised = true
          raise "Some unexpected exception"
        else
          false
        end
      end

      expect(object).not_to be_foo.during(0.1)
      expect(raised).to be true
    end    
  end

  def should_take_at_least(seconds)
    t = Time.now
    yield
    expect(Time.now - t).to be >= seconds
  end
end

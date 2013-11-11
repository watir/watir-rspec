require "spec_helper"

class TestModel < ::ActiveRecord::Base
end

describe TestModel do
  context ".connection" do
    before { described_class.class_variable_set :@@shared_connection, nil }

    it "reuses the connection" do
      described_class.should_receive(:retrieve_connection).once.and_return(:established_connection)

      2.times { described_class.connection.should == :established_connection }
    end

    it "uses mutex" do
      described_class.should_receive(:retrieve_connection).once { sleep 0.1; :established_connection }

      thr = Thread.new { described_class.connection }

      t = Time.now
      described_class.connection
      (Time.now - t).should be >= 0.1
      thr.join
    end
  end
end

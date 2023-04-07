require "spec_helper"

class TestModel < ::ActiveRecord::Base
end

describe TestModel do
  context ".connection" do
    before { ActiveRecord::Base.class_variable_set :@@shared_connection, nil }

    it "reuses the connection" do
      expect(described_class).to receive(:retrieve_connection).once.and_return(:established_connection)

      2.times { expect(described_class.connection).to be_eql :established_connection }
    end

    it "uses mutex" do
      expect(described_class).to receive(:retrieve_connection).once { sleep 0.1; :established_connection }

      thr = Thread.new { described_class.connection }

      t = Time.now
      described_class.connection
      expect(Time.now - t).to be >= 0.1
      thr.join
    end
  end
end

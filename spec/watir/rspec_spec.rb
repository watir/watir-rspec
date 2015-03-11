require "spec_helper"

describe Watir::RSpec do
  context "#file_path" do
    it "without description" do
      formatter = double("formatter", file_path: "file-path")
      Watir::RSpec.stub(formatter: formatter)
      formatter.should_receive(:file_path).with("name", nil)

      Watir::RSpec.file_path("name").should == "file-path"
    end

    it "with description" do
      formatter = double("formatter", file_path: "file-path")
      Watir::RSpec.stub(formatter: formatter)
      formatter.should_receive(:file_path).with("name", "description")

      Watir::RSpec.file_path("name", "description").should == "file-path"
    end
  end
end

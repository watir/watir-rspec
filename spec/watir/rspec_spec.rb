require "spec_helper"

describe Watir::RSpec do
  context "#file_path" do
    it "without description" do
      formatter = double("formatter", file_path: "file-path")
      allow(Watir::RSpec).to receive (:formatter) {formatter}
      expect(formatter).to receive(:file_path).with("name", nil)

      expect(Watir::RSpec.file_path("name")).to be == "file-path"
    end

    it "with description" do
      formatter = double("formatter", file_path: "file-path")
      allow(Watir::RSpec).to receive (:formatter) {formatter}
      expect(formatter).to receive(:file_path).with("name", "description")

      expect(Watir::RSpec.file_path("name", "description")).to be == "file-path"
    end
  end
end

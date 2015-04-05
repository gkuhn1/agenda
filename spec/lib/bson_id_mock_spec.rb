require 'rails_helper'

RSpec.describe BSON::ObjectId, type: :lib do

  let(:bson) { BSON::ObjectId.new }

  context "to_json" do
    it "should return to_s" do
      expect(bson).to receive(:to_s).twice.and_call_original
      expect(bson.to_json).to eq(bson.to_s)
    end
  end

  context "as_json" do
    it "should return to_s" do
      expect(bson).to receive(:to_s).twice.and_call_original
      expect(bson.as_json).to eq(bson.to_s)
    end
  end
end
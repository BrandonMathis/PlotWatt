require 'spec_helper.rb'

describe "Mongoid" do
  it "Give list of fields" do
    Measurment.fields.should_not be_nil
  end
  When { @entity = Measurment.create(:always_on => 10) }
  Then { @entity.fields.should_not be_nil }
end

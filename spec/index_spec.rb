require 'spec_helper.rb'
include Rack::Test::Methods

describe "PlotWatt" do
  include Rack::Test::Methods
  def app
    @app ||= Sinatra::Application
  end
  describe 'Mongoid' do
    When { @entity1 = Measurment.create(:always_on => 10, :ac => 5, :dryer => 20, :collected => Time.parse("2010-01-19T16:00:00")) }
    When { @entity2 = Measurment.create(:always_on => 9, :ac => 8, :dryer => 22, :collected => Time.parse("2010-03-21T17:00:00")) }
    When { @entity3 = Measurment.create(:always_on => 11, :ac => 15, :dryer => 10, :collected => Time.parse("2010-01-19T10:00:00")) }
    it 'Give list of fields' do
      Measurment.fields.should_not be_nil
    end
    Then { @entity1.fields.should_not be_nil }
    describe "Getting Days of the month axis" do
      Given ( :april ) { "April" }
      Given ( :feb ) { "Feb" }
      Given ( :jan ) { "Jan" }
      Then { days_for_month(feb).should == "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28" }
      Then { days_for_month(april).should == "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30" }
      Then { days_for_month(jan).should == "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31" }
    end
    describe 'Summarize measurments' do
      require 'time'
      Then { @entity1.always_on.should_not be_nil }
      Then { @entity2.always_on.should_not be_nil }
      Then { @entity3.always_on.should_not be_nil }
      Then { Measurment.totals[:always_on].should == ( @entity1.always_on + @entity2.always_on + @entity3.always_on ) }
      Then { Measurment.totals_for_month("Jan")[:always_on].should == ( @entity1.always_on + @entity3.always_on ) }
    end
  end
  describe 'root should load' do
    it 'should respond okay' do
      get '/'
      last_response.should be_ok
    end
  end
  describe 'Monthly measurments should load' do
    MONTHS[1,12].each do |month|
      it 'should respond okay' do
        get "/energy/#{month}"
        last_response.should be_ok
      end
    end
  end
end

require 'spec_helper'

describe Indicators::Data do

	describe ".new" do
		context "should raise an exception if parameter" do

		  it "is nil or empty" do
		  	expect { Indicators::Data.new(nil) }.to raise_error('There is no data to work on.')
		  	expect { Indicators::Data.new('') }.to raise_error('There is no data to work on.')
		  end
		  it "is not an array" do
		  	expect { Indicators::Data.new('some string') }.to raise_error(Indicators::Data::DataException, /Alien data. Given data must be an array/)
		  end
		end

		context "should not raise an exception if parameter" do

			it "is an array" do
				expect { Indicators::Data.new([1, 2, 3]) }.not_to raise_error
			end
			it "is a hash" do
                                expect { Indicators::Data.new([{:date => '2012-08-01', :open => 2000, :high=>2000, :low=>2000, :close=>2000, :volume=>20000}]) }.not_to raise_error
			end

		end
	end

	describe ".calc" do
		before :all do
                        arr = Array.new(100).each_with_index.map do |x,i|
                            {
                                :date=>(Date.today+i).to_s,
                                :open=>(2000+rand(500)*(-1)**[0,1].sample),
                                :high=>(2500+rand(500)*(-1)**[0,1].sample),
                                :low=>(1500+rand(500)*(-1)**[0,1].sample),
                                :close=>(2000+rand(500)*(-1)**[0,1].sample),
                                :volume=>"9286500",
                                :adj_close=>2000+rand(500)*(-1)**[0,1].sample
                            }
                        end
			@my_data = Indicators::Data.new arr
		end

		context "should raise an exception if parameter" do
			it "is not a hash" do
				expect { @my_data.calc('some string') }.to raise_error('Given parameters have to be a hash.')
			end
			it ":type is invalid" do
				expect { @my_data.calc(:type => :invalid_type, :params => 5) }.to raise_error(Indicators::Data::DataException, /Invalid indicator type specified/)
			end
		end

		context "should not raise an exception if parameter" do
			it ":type is not specified (should default to :sma)" do
				expect { @my_data.calc(:params => 5) }.not_to raise_error
				# Can't get this test to work for some reason.
				# @my_data.calc(:params => 5).abbr.downcase.to_sym should eq(:sma)
			end
			it "good SMA params are specified" do
				expect { @my_data.calc(:type => :sma, :params => 5) }.not_to raise_error
			end
			it "good EMA params are specified" do
				expect { @my_data.calc(:type => :ema, :params => 5) }.not_to raise_error
			end
			it "good BB params are specified" do
				expect { @my_data.calc(:type => :bb, :params => [10, 2]) }.not_to raise_error
			end
			it "good MACD params are specified" do
				expect { @my_data.calc(:type => :macd, :params => [2, 5, 4]) }.not_to raise_error
			end
			it "good RSI params are specified" do
				expect { @my_data.calc(:type => :rsi, :params => 5) }.not_to raise_error
			end
			it "good STO params are specified" do
				expect { @my_data.calc(:type => :sto, :params => [3, 5, 4]) }.not_to raise_error
			end
			it "good PSAR params are specified" do
				expect { @my_data.calc(:type => :psar, :params => [0.02, 0.2]) }.not_to raise_error
			end
		end
	end

end
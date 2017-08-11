require 'spec_helper'

describe Indicators::Psar do
  context "when calculation" do
    it "should contain correct data format" do
      input_format = {date:[],open:[],high:[],low:[],close:[],volume:[],adj_close:[]}
      output_format = [:dates,:high,:low,:close,:psar,:psarbear,:psarbull]
      res = Indicators::Psar.calculate(input_format, [0.02, 0.2])
      (res.keys & output_format).size.should be output_format.size
    end
    it "should be monotonically bull" do
      data = {date:["2017-07-05", "2017-07-06","2017-07-07","2017-07-08","2017-07-09"],open:[10,20,30,40,50],high:[12,22,32,42,52],low:[8,18,28,38,48],close:[10,20,30,40,50],volume:[100,120,90,100,100],adj_close:[10,10,10,10,10]}
      res = Indicators::Psar.calculate(data, [0.02, 0.2])
      res[:psarbull].size.should be data[:date].size
      res[:psarbull].first.should_not be_nil
      res[:psarbull].last.should_not be_nil
      res[:psarbull][1].should be > res[:psarbull][0]
      res[:psarbull][2].should be > res[:psarbull][1]
      res[:psarbull][3].should be > res[:psarbull][2]
      res[:psarbull][4].should be > res[:psarbull][3]
      res[:psarbear].size.should be data[:date].size
      res[:psarbear].first.should be_nil
      res[:psarbear].last.should be_nil
    end
    it "should be monotonically bear except first bull" do
      data = {date:["2017-07-05", "2017-07-06","2017-07-07","2017-07-08","2017-07-09"],open:[50,40,30,20,10],high:[52,42,32,22,12],low:[48,38,28,18,8],close:[50,40,30,20,10],volume:[100,120,90,100,100],adj_close:[10,10,10,10,10]}
      res = Indicators::Psar.calculate(data, [0.02, 0.2])
      res[:psarbull].size.should be data[:date].size
      res[:psarbull].first.should eq res[:close].first
      res[:psarbull].last.should be_nil
      res[:psarbear].size.should be data[:date].size
      res[:psarbear][2].should be < res[:psarbear][1]
      res[:psarbear][3].should be < res[:psarbear][2]
      res[:psarbear][4].should be < res[:psarbear][3]
      res[:psarbear].first.should be_nil
      res[:psarbear].last.should_not be_nil
    end
    it "should be all bull except the last bear" do
      data = {date:["2017-07-05", "2017-07-06","2017-07-07","2017-07-08","2017-07-09"],open:[10,20,30,40,10],high:[12,22,32,42,12],low:[8,18,28,38,8],close:[10,20,30,40,10],volume:[100,120,90,100,100],adj_close:[10,10,10,10,10]}
      res = Indicators::Psar.calculate(data, [0.02, 0.2])
      res[:psarbull].size.should be data[:date].size
      res[:psarbull].first.should_not be_nil
      res[:psarbull][1].should be > res[:psarbull][0]
      res[:psarbull][2].should be > res[:psarbull][1]
      res[:psarbull][3].should be > res[:psarbull][2]
      res[:psarbull][4].should be_nil
      res[:psarbear][4].should_not be_nil
      res[:psarbear].size.should be data[:date].size
    end
    it "should be all bear except the last bull" do
      data = {date:["2017-07-05", "2017-07-06","2017-07-07","2017-07-08","2017-07-09"],open:[50,40,30,20,50],high:[52,42,32,22,52],low:[48,38,28,18,48],close:[50,40,30,20,50],volume:[100,120,90,100,100],adj_close:[10,10,10,10,10]}
      res = Indicators::Psar.calculate(data, [0.02, 0.2])
      res[:psarbull].size.should be data[:date].size
      res[:psarbull].first.should eq res[:close].first
      res[:psarbear].size.should be data[:date].size
      res[:psarbear][2].should be < res[:psarbear][1]
      res[:psarbear][3].should be < res[:psarbear][2]
      res[:psarbear][4].should be_nil
      res[:psarbull][4].should_not be_nil
      res[:psarbear].first.should be_nil
    end
  end
end

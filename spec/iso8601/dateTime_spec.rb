# encoding: utf-8

require 'spec_helper'

describe ISO8601::DateTime do
  it "should raise a ISO8601::Errors::UnknownPattern for any unknown pattern" do
    expect { ISO8601::DateTime.new('2') }.to raise_error(ISO8601::Errors::UnknownPattern)
    expect { ISO8601::DateTime.new('201') }.to raise_error(ISO8601::Errors::UnknownPattern)
    expect { ISO8601::DateTime.new('2010-') }.to raise_error(ISO8601::Errors::UnknownPattern)
    expect { ISO8601::DateTime.new('2010-') }.to raise_error(ISO8601::Errors::UnknownPattern)
    expect { ISO8601::DateTime.new('20-05') }.to raise_error(ISO8601::Errors::UnknownPattern)
    expect { ISO8601::DateTime.new('2010-0') }.to raise_error(ISO8601::Errors::UnknownPattern)
    expect { ISO8601::DateTime.new('2010-0-09') }.to raise_error(ISO8601::Errors::UnknownPattern)
    expect { ISO8601::DateTime.new('2010-1-09') }.to raise_error(ISO8601::Errors::UnknownPattern)
    expect { ISO8601::DateTime.new('201001-09') }.to raise_error(ISO8601::Errors::UnknownPattern)
    expect { ISO8601::DateTime.new('201-0109') }.to raise_error(ISO8601::Errors::UnknownPattern)
    expect { ISO8601::DateTime.new('2010-05-09T103012+0400') }.to raise_error(ISO8601::Errors::UnknownPattern)
    expect { ISO8601::DateTime.new('20100509T10:30:12+04:00') }.to raise_error(ISO8601::Errors::UnknownPattern)
  end
  it "should raise a RangeError for a correct pattern but an invalid date" do
    expect { ISO8601::DateTime.new('2010-01-32') }.to raise_error(RangeError)
    expect { ISO8601::DateTime.new('2010-02-30') }.to raise_error(RangeError)
    expect { ISO8601::DateTime.new('2010-13-30') }.to raise_error(RangeError)
  end

  it "should parse the reduced precision year (just the century)" do
    expect { ISO8601::DateTime.new('20') }.to_not raise_error
    ISO8601::DateTime.new('20').year.should == 2000
  end

  it "should parse any allowed pattern" do
    expect { ISO8601::DateTime.new('2010') }.to_not raise_error
    expect { ISO8601::DateTime.new('2010-05') }.to_not raise_error
    expect { ISO8601::DateTime.new('2010-05-09') }.to_not raise_error
    expect { ISO8601::DateTime.new('2010-05-09T10') }.to_not raise_error
    expect { ISO8601::DateTime.new('2010-05-09T10:30') }.to_not raise_error
    expect { ISO8601::DateTime.new('2010-05-09T10:30:12') }.to_not raise_error
    expect { ISO8601::DateTime.new('2010-05-09T10:30:12Z') }.to_not raise_error
    expect { ISO8601::DateTime.new('2010-05-09T10:30:12+04') }.to_not raise_error
    expect { ISO8601::DateTime.new('2010-05-09T10:30:12+04:00') }.to_not raise_error
    expect { ISO8601::DateTime.new('2010-05-09T10:30:12-04:00') }.to_not raise_error
  end
  it "should parse correctly any allowed reduced pattern" do
    expect { ISO8601::DateTime.new('20') }.to_not raise_error
    #expect { ISO8601::DateTime.new('201005') }.to_not raise_error
    #ISO8601::DateTime.new('201005').year.should == 2000
    #ISO8601::DateTime.new('201005').month.should == 10
    #ISO8601::DateTime.new('201005').day.should == 5

    expect { ISO8601::DateTime.new('20100509') }.to_not raise_error
    ISO8601::DateTime.new('20100509').year.should == 2010
    ISO8601::DateTime.new('20100509').month.should == 5
    ISO8601::DateTime.new('20100509').day.should == 9

    expect { ISO8601::DateTime.new('20100509T103012') }.to_not raise_error
    expect { ISO8601::DateTime.new('20100509T103012Z') }.to_not raise_error
    expect { ISO8601::DateTime.new('20100509T103012+04') }.to_not raise_error
    expect { ISO8601::DateTime.new('20100509T103012+0400') }.to_not raise_error
    expect { ISO8601::DateTime.new('20100509T103012-0400') }.to_not raise_error
  end

  it "should return each atomic value" do
    dt = ISO8601::DateTime.new('2010-05-09T12:02:01+04:00')
    dt.century.should == 20
    dt.year.should == 2010
    dt.month.should == 5
    dt.day.should == 9
    dt.hour.should == 12
    dt.minute.should == 2
    dt.second.should == 1
    dt.timezone[:full].should == '+04:00'
    dt.timezone[:sign].should == '+'
    dt.timezone[:hour].should == 4
    dt.timezone[:minute].should == 0
    dt = ISO8601::DateTime.new('2010-05-09T10Z')
    dt.century.should == 20
    dt.year.should == 2010
    dt.month.should == 5
    dt.day.should == 9
    dt.hour.should == 10
    dt.minute.should == nil
    dt.second.should == nil
    dt.timezone[:full].should == 0
    dt.timezone[:sign].should == nil
    dt.timezone[:hour].should == 0
    dt.timezone[:minute].should == 0
  end
  describe '#to_s' do
    it "should return the string representation" do
      ISO8601::DateTime.new('2010-05-09').to_s.should == '2010-05-09'
    end
  end
  describe '#to_time' do
    it "should return a Time instance" do
      ISO8601::DateTime.new('20').to_time.should be_an_instance_of(Time)
      ISO8601::DateTime.new('2010').to_time.should be_an_instance_of(Time)
      ISO8601::DateTime.new('2010-05').to_time.should be_an_instance_of(Time)
      ISO8601::DateTime.new('2010-05-09').to_time.should be_an_instance_of(Time)
      ISO8601::DateTime.new('2010-05-09T12').to_time.should be_an_instance_of(Time)
      ISO8601::DateTime.new('2010-05-09T12:02').to_time.should be_an_instance_of(Time)
      ISO8601::DateTime.new('2010-05-09T12:02:01').to_time.should be_an_instance_of(Time)
      ISO8601::DateTime.new('2010-05-09T12:02:01+04').to_time.should be_an_instance_of(Time)
      ISO8601::DateTime.new('2010-05-09T12:02:01+04:00').to_time.should be_an_instance_of(Time)
      ISO8601::DateTime.new('2010-05-09T12:02:01-04:00').to_time.should be_an_instance_of(Time)
    end
  end

  describe '#+' do
    it "should return the result of the addition" do
      (ISO8601::DateTime.new('2012-07-07T20:20:20Z') + 10).to_time.should == ISO8601::DateTime.new('2012-07-07T20:20:30Z').to_time
    end
  end

  describe '#-' do
    it "should return the result of the substraction" do
      (ISO8601::DateTime.new('2012-07-07T20:20:20Z') - 10).to_time.should == ISO8601::DateTime.new('2012-07-07T20:20:10+00:00').to_time
    end
  end

end

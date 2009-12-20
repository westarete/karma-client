require File.dirname(__FILE__) + '/spec_helper'

describe Proxy do
  before(:each) do
    @buckets = { :comments => 1, :edits => 2 }
    @proxy = Proxy.new(@buckets)
  end
  it "should be a Fixnum" do
    @proxy.kind_of?(Fixnum).should be_true
  end
  it "should be equal to the karma total" do
    @proxy.should == 3
  end
  it "should have a getter for each bucket" do
    @proxy.comments.should == 1
    @proxy.edits.should == 2
  end
  it "should have a setter for each bucket" do
    @proxy.comments += 1
    @proxy.comments.should == 2
    @proxy.edits -= 1
    @proxy.edits.should == 1
  end
  it "should update the total when the buckets are updated" do
    @proxy.should == 3
    @proxy.comments += 2
    @proxy.should == 5
  end
end
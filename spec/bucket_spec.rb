require File.dirname(__FILE__) + '/spec_helper'

describe 'Karma::BUCKETS' do
  
  it "should contain some symbols" do
    BUCKETS.should_not be_empty
    BUCKETS.first.kind_of?(Symbol).should be_true
  end
  
end
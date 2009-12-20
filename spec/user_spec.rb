require File.dirname(__FILE__) + '/spec_helper'

class TestUser
  include Karma::User
end

describe User do
  before(:each) do
    @user = TestUser.new
  end
  it "should provide access to the user's total karma" do
    @user.karma.should == 0
  end
  it "should provide access to the user's karma buckets" do
    @user.karma.comments.should == 0
  end
  it "should allow updating of the user's karma buckets" do
    @user.karma.comments += 1
    @user.karma.comments.should == 1
    @user.karma.should == 1
  end
  it "should update the @buckets instance variable" do
    @user.karma.edits += 2
    @user.instance_variable_get(:@buckets)[:edits].should == 2
  end
end
# For best results, run this file with the command:
#   spec -c -f n karma_proxy.rb

require 'rubygems'
require 'active_support'

# This module provides all the client-side functionality that the web app 
# will need to integrate with a Karma server.
module Karma

  # The buckets that are defined on the karma server.
  BUCKETS = [:comments, :edits]

  # A class that has had all instance methods stripped except for __id__ and
  # __send__. This provides the basis for a good proxy object.
  class BlankSlate 
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
  end
  
  # A proxy object that behaves like a Fixnum for the total karma value, but
  # is also decorated with a #for method for accessing the bucket values that
  # make up the total.
  class KarmaValueProxy < BlankSlate
    # Initialize with a hash of all the karma bucket values. This object will
    # proxy all methods back to the total value of the buckets (the karma
    # total).
    def initialize(buckets)
      @buckets = buckets
    end
    
    # Proxy any unknown method to the karma total (a Fixnum).
    def method_missing(sym, *args, &block)
      @buckets.values.sum.__send__(sym, *args, &block)
    end    

    # Define accessor methods for retrieving and setting the values of each
    # bucket. We are essentially decorating the karma total with these
    # methods.
    BUCKETS.each do |bucket_name|
      # Define the getter.
      define_method(bucket_name) do
        @buckets[bucket_name]
      end
      
      # Define the setter.
      define_method("#{bucket_name}=") do |new_value|
        @buckets[bucket_name] = new_value
      end
    end        
  end
  
  # Provide karma capability to a user model.
  module User
    # Return the user's total karma.
    def karma
      @buckets ||= Hash.new(0)
      KarmaValueProxy.new(@buckets)
    end
  end

end

# An example User class to demonstrate the use of the UserKarma module.
class User
  include Karma::User  
end

# Describe and test the desired behavior using rspec.
describe User do
  before(:each) do
    @user = User.new
  end
  describe "#karma" do
    it "should return a Fixnum" do
      @user.karma.class.should == Fixnum
    end
    it "should start out at zero" do
      @user.karma.should == 0
    end
    describe "#comments (a bucket name)" do
      it "should start out at zero" do
        @user.karma.comments.should == 0
      end
      it "should be assignable" do
        @user.karma.comments = 12
        @user.karma.comments.should == 12
      end
      it "should be increasable" do
        @user.karma.comments += 3
        @user.karma.comments.should == 3
      end
      it "should be decreasable" do
        @user.karma.comments = 3
        @user.karma.comments -= 1
        @user.karma.comments.should == 2
      end
      it "should be reflected in the total karma" do
        @user.karma.comments = 3
        @user.karma.should == 3
        @user.karma.comments += 1
        @user.karma.comments.should == 4
        @user.karma.should == 4
      end
      it "should update the User object's copy of the karma as well" do
        @user.karma.should == 0
        @user.karma.comments.should == 0
        @user.karma.comments = 3
        @user.instance_variable_get(:@buckets)[:comments].should == 3
      end
    end
    describe "#edits (another bucket name)" do
      it "should be independent of the comments bucket" do
        @user.karma.comments = 3
        @user.karma.comments.should == 3
        @user.karma.edits.should    == 0
        @user.karma.should          == 3
        
        @user.karma.edits = 2
        @user.karma.comments.should == 3
        @user.karma.edits.should    == 2
        @user.karma.should          == 5
        
        @user.karma.comments += 1
        @user.karma.comments.should == 4
        @user.karma.edits.should    == 2
        @user.karma.should          == 6
        
        @user.karma.edits += 1
        @user.karma.comments.should == 4
        @user.karma.edits.should    == 3
        @user.karma.should          == 7
      end
    end
    describe "a non-existent bucket" do
      it "should raise a NoMethodError" do
        lambda {
          @user.karma.not_there
        }.should raise_error(NoMethodError)
      end
    end
  end
end

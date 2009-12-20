# For best results, run this file with the command:
#   spec -c -f n karma_proxy.rb

# This module provides all the client-side functionality that the web app 
# will need to integrate with a Karma server.
module Karma

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
    # proxy all methods back to the :total value in the hash.
    def initialize(karma)
      @karma = karma
    end
    
    # Provide a method for accessing the karma value in a given bucket.
    def for(bucket)
      @karma[bucket]
    end
    
    # Proxy any other method to the total.
    def method_missing(sym, *args, &block)
      @karma[:total].__send__(sym, *args, &block)
    end
  end
  
  # Provide karma capability to a user model.
  module User
    # Return the user's total karma.
    def karma
      @karma ||= Hash.new(0)
      KarmaValueProxy.new(@karma)
    end
    
    # Set the user's total karma.
    def karma=(new_value)
      @karma ||= Hash.new(0)
      @karma[:total] = new_value
      KarmaValueProxy.new(@karma)
    end    
  end

end

# An example User class to demonstrate the use of the UserKarma module.
class User
  include Karma::User  
end

# Describe and test the desired behavior using rspec.
#
# user = User.find(1)
# user.karma                        # => 12
# user.karma.commenting             # => 6
# user.karma.commenting += 1        # => 7
# user.karma                        # => 13
# user.karma += 2                   # => 15
# user.karma                        # => 15
# user.save!

describe User do
  before(:each) do
    @user = User.new
  end
  describe "#karma" do
    it "should start out at zero" do
      @user.karma.should == 0
    end
    it "should be assignable" do
      @user.karma = 12
      @user.karma.should == 12
    end
    it "should be increasable" do
      @user.karma += 3
      @user.karma.should == 3
    end
    it "should be decreasable" do
      @user.karma = 3
      @user.karma -= 1
      @user.karma.should == 2
    end
  end
end

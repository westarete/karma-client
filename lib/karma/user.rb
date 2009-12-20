module Karma

  # Provide karma capability to a user model.
  module User
    
    # Provide access to the user's karma.
    def karma
      @buckets ||= Hash.new(0)
      Proxy.new(@buckets)
    end
    
  end

end
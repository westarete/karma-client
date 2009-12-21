module Karma

  # Provide karma capability to a user model.
  module User
    
    # Provide access to the user's karma.
    def karma
      if @buckets.nil?
        @buckets = {}
        BUCKETS.each { |name| @buckets[name] = 0 }
      end
      Proxy.new(@buckets)
    end
    
  end

end
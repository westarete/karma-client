module Karma

  # A class that has had all instance methods stripped except for __id__ and
  # __send__. This provides the basis for a good proxy object.
  #
  # Thanks to Jim Weirich for the idea and explanation:
  # http://onestepback.org/index.cgi/Tech/Ruby/BlankSlate.rdoc
  class BlankSlate 
    instance_methods.each { |m| undef_method m unless m =~ /^__/ }
  end

end
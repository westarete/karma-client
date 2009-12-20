$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'karma'
require 'spec'
require 'spec/autorun'

include Karma

Spec::Runner.configure do |config|
  
end

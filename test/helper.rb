require 'minitest/autorun'
require 'minitest/pride'
require 'richard_iii'

include Richard

dir = File.join(File.dirname(__FILE__))

Dir.glob(File.join(dir, "support", "**", "*.rb")).each {|f| require f}

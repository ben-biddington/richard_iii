require 'minitest/unit'

Richard::CurlReply.class_eval do
  include MiniTest::Assertions
  def must_match(expected)
    assert(self.matches?(expected), "Expected <#{self}> to match <#{expected}>")
  end
end

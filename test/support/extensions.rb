Richard::CurlReply.class_eval do
  include MiniTest::Assertions

  def assertions=(what)
    @assertions ||= what
  end

  def assertions
    @assertions ||= 0
  end
  
  def must_match(expected)
    assert(self.matches?(expected), "Expected <#{self}> to match <#{expected}>")
  end

  def must_not_match(expected)
    assert(false === self.matches?(expected), "Expected <#{self}> not to match <#{expected}>")
  end
end

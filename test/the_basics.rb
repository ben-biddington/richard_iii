require 'minitest/autorun'
require 'minitest/pride'

module Richard
  class III
    def initialize(opts={})
      @internet = opts[:internet] || fail("You need to supply :internet")
    end

    def exec(text)
      "xxx"
    end
  end
end

describe 'The basics of Richard III' do
  it "can issue a very simple request" do
    spy_internet = MiniTest::Mock.new

    spy_internet.expect :execute, nil, []

    richard_iii = Richard::III.new :internet => spy_internet

    richard_iii.exec <<-TEXT 
      GET /1.1/statuses
      Host: api.twitter.com
      Accept: application/json
    TEXT

    spy_internet.verify
  end
end

require 'minitest/autorun'
require 'minitest/pride'

describe 'The basics of Richard III' do
  it "can issue a very simple request" do
    spy_internet = MiniTest::Mock.new

    spy_internet.expect :execute, nil, []

    richard_iii = Richard::III.new spy_internet

    richard_iii.exec <<-TEXT 
      GET /1.1/statuses
      Host: api.twitter.com
      Accept: application/json
    TEXT

    spy_internet.verify
  end
end

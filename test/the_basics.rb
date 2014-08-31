require File.join '.', 'test', 'helper'

describe 'The basics of Richard III' do
  it "can issue a very simple request" do
    spy_internet = MiniTest::Mock.new

    spy_internet.expect :execute, nil do |actual|
      actual.first.eql? Request.new(:verb => 'GET', :uri => 'https://api.twitter.com/1.1/statuses')
    end

    richard_iii = Richard::III.new :internet => spy_internet

    richard_iii.exec <<-TEXT 
      GET /1.1/statuses
      Host: api.twitter.com
      Accept: application/json
    TEXT

    spy_internet.verify
  end

  # TEST: where does it read the protocol part (HTTP of HTTPS)
end

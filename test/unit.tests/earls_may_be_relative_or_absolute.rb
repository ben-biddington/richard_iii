require File.join '.', 'test', 'helper'

describe "Request earls may be absolute or relative" do 
  it "must have host header when relative" do
    spy_internet = SpyInternet.new

    richard_iii = Richard::III.new :internet => spy_internet

    err = lambda { richard_iii.exec 'GET /1.1/statuses' }.must_raise RuntimeError

    err.message.must_match /missing host header/i
  end

  it "ignores host header when earl is absolute -- that is it does not send it"
end

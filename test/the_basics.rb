require File.join '.', 'test', 'helper'

class SpyInternet
  def initialize
    @requests = []
  end

  def execute(request)
    @requests << request
  end

  def must_have_been_asked_to_execute(what)
    @requests.any?{|it| it.eql? what}.must_be :==, true, "Unable to locate match for:\n\n#{what.inspect}\n\nin:\n\n#{@requests.inspect}"
  end
end

describe 'The basics of Richard III' do
  it "can issue a very simple request" do
    spy_internet = SpyInternet.new

    richard_iii = Richard::III.new :internet => spy_internet

    richard_iii.exec <<-TEXT 
      GET /1.1/statuses
      Host: api.twitter.com
      Accept: application/json
    TEXT

    spy_internet.must_have_been_asked_to_execute(
      Request.new(
        :verb    => 'GET', 
        :uri     => 'https://api.twitter.com/1.1/statuses',
        :headers => {
           'Host'   => 'api.twitter.com',
           'Accept' => 'application/json'
        }
      )
    )
  end

  # TEST: where does it read the protocol part (HTTP of HTTPS)
  # TEST: looks like you can either supply absolute uri, or relative AND Host header
end

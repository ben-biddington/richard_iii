require File.join '.', 'test', 'helper'

class SystemInternet
  class << self
    def execute(request)
      require 't'
      reply = T::Internet.new.execute(T::Request.new(:verb => :get, :uri => "http://api.twitter.com/1.1/statuses"))

      Richard::Response.new :status => reply.code
    end
  end
end

describe "the internet adapter" do
  it "can be asked to execute a basic get" do
    reply = SystemInternet.execute Request.new(:verb => "GET", :uri => "http://api.twitter.com/1.1/statuses")
    reply.status.must_equal 400
  end
end

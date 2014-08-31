require File.join '.', 'test', 'helper'

describe 'The basics of Richard III' do
  it "can issue a very simple GET request" do
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

  it "can issue a very simple POST request" do
    spy_internet = SpyInternet.new

    richard_iii = Richard::III.new :internet => spy_internet

    richard_iii.exec <<-TEXT 
      POST /1.1/statuses/update
      Host: api.twitter.com
      Accept: application/json
      Content-type: application/x-www-form-urlencoded

      status=Who%20says%20famine%20has%20to%20be%20depressing?
    TEXT

    spy_internet.must_have_been_asked_to_execute(
      Request.new(
        :verb    => 'POST', 
        :uri     => 'https://api.twitter.com/1.1/statuses/update',
        :headers => {
           'Host'         => 'api.twitter.com',
           'Accept'       => 'application/json',
           'Content-type' => 'application/x-www-form-urlencoded'
        },
        :body => 'status=Who%20says%20famine%20has%20to%20be%20depressing?'
      )
    )
  end

  it "can be used to conduct a conversation" do
    internet = SpyInternet.new

    richard_iii = Richard::III.new :internet => internet

    internet.always_return(
      Response.new(
        :status  => Status.new(400, 'Bad Request'),          
        :headers => {
           'content-length'            => 24,
           'content-type'              => 'text/plain;charset=utf-8',
           'date'                      => 'Sat, 30 Aug 2014 01:30:43 UTC',
           'server'                    => 'tsa_a',
           'set-cookie'                => 'guest_id=v1%3A140936224322485447; Domain=.twitter.com; Path=/; Expires=Mon, 29-Aug-2016 01:30:43 UTC',
           'strict-transport-security' => 'max-age=631138519',
           'x-connection-hash'         => '7710cb2762e0a47702d21bb7e10d3056'
        },
        :body => 'Bad Authentication data'
      )
    )

    reply = richard_iii.exec <<-TEXT 
      GET /1.1/statuses
      Host: api.twitter.com
      Accept: application/json
    TEXT

puts reply

    reply.must_equal <<-REPLY 
HTTP/1.1 400 Bad Request
content-length: 24
content-type: text/plain;charset=utf-8
date: Sat, 30 Aug 2014 01:30:43 UTC
server: tsa_a
set-cookie: guest_id=v1%3A140936224322485447; Domain=.twitter.com; Path=/; Expires=Mon, 29-Aug-2016 01:30:43 UTC
strict-transport-security: max-age=631138519
x-connection-hash: 7710cb2762e0a47702d21bb7e10d3056
  
Bad Authentication data
REPLY
  end
  
  # TEST: quotes are treated literally
  # TEST: whitespace does not matter
  # TEST: where does it read the protocol part (HTTP or HTTPS)
  # TEST: looks like you can either supply absolute uri, or relative AND Host header
end

require File.join '.', 'test', 'helper'

describe "Full conversations" do 
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

    assert_equal reply, <<-REPLY 
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

  #TEST: You need to be able to match headers partially to avoid for example set-cookie above
end

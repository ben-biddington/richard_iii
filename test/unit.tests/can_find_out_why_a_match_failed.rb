require File.join '.', 'test', 'helper'

describe "Finding out why a match failed" do 
  before do
    @internet = SpyInternet.new

    @internet.always_return(
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

    richard_iii = Richard::III.new :internet => @internet

    @reply = richard_iii.exec <<-TEXT 
      GET /1.1/statuses
      Host: api.twitter.com
      Accept: application/json
    TEXT
  end

  it "returns something that knows which expected lines are missing" do
    expected = <<-REPLY 
      HTTP/1.1 400 Bad Request
      content-type: text/plain;charset=utf-8

      xxx_body_differs_xxx
    REPLY

    @reply.must_not_match expected

    @reply.missing.must_equal ['xxx_body_differs_xxx']
  end

  it "returns something that knows which actual lines are surplus" do
    expected = <<-REPLY 
      HTTP/1.1 400 Bad Request
      content-type: text/plain;charset=utf-8

      xxx_body_differs_xxx
    REPLY

    @reply.must_not_match expected

    @reply.surplus.must_equal [
      "content-length: 24", 
      "date: Sat, 30 Aug 2014 01:30:43 UTC", 
      "server: tsa_a", 
      "set-cookie: guest_id=v1%3A140936224322485447; Domain=.twitter.com; Path=/; Expires=Mon, 29-Aug-2016 01:30:43 UTC", 
      "strict-transport-security: max-age=631138519", 
      "x-connection-hash: 7710cb2762e0a47702d21bb7e10d3056", 
      "Bad Authentication data"
    ]
  end
end

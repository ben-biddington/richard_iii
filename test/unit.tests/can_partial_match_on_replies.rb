require File.join '.', 'test', 'helper'

describe "Partial matching replies" do 
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

  it "can match partially, so that you can ignore headers like date" do
    expected = <<-REPLY 
      HTTP/1.1 400 Bad Request
      content-type: text/plain;charset=utf-8

      Bad Authentication data
    REPLY

    @reply.must_match expected
  end

  it "fails when the response line does not match" do
    expected = <<-REPLY 
      HTTP/1.1 XXX_BAD_RESPONSE_LINE
      content-type: text/plain;charset=utf-8

      Bad Authentication data
    REPLY

    @reply.must_not_match expected
  end

  it "fails, for example, when you expected a header that is not present" do
    expected = <<-REPLY 
      HTTP/1.1 400 Bad Request
      xxx: this_one_is_not_present

      Bad Authentication data
    REPLY

    @reply.must_not_match expected
  end

  it "fails when the body does not match" do
    expected = <<-REPLY 
      HTTP/1.1 400 Bad Request
      content-type: text/plain;charset=utf-8

      Who says famine has to be depressing
    REPLY

    @reply.must_not_match expected
  end
end

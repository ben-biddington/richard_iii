require File.join '.', 'test', 'helper'

describe "Pattern matching on reply lines" do
  before do
    @curl_reply = CurlReply.new <<-TEXT
      HTTP/1.1 400 Bad Request
      
      content-type: text/plain;charset=utf-8
      date: Sat, 30 Aug 2014 01:30:43 UTC
      server: tsa_a
      set-cookie: guest_id=v1%3A140936224322485447; Domain=.twitter.com; Path=/; Expires=Mon, 29-Aug-2016 01:30:43 UTC
      strict-transport-security: max-age=631138519
      x-connection-hash: 7710cb2762e0a47702d21bb7e10d3056

      Bad Authentication data
    TEXT
  end

  it "allows you to match part of a dynamic header, for example" do
    @curl_reply.must_match <<-REPLY 
      HTTP/1.1 400 Bad Request
      content-type: text/plain;charset=utf-8
      /set-cookie: .+Domain=.twitter.com; Path=\/;/
    REPLY
  end

  it "another example might be /content-length: \d+/" do 
    skip("WIP: for some reason the backslash is being dropped")
    @curl_reply.must_match <<-REPLY 
      HTTP/1.1 400 Bad Request
      content-type: text/plain;charset=utf-8
      /content-length: \d+/
    REPLY
  end

  it "how are we going to fail in a way that tells you a pattern match failed?"
end

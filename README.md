# Richard III

[![Build Status](https://secure.travis-ci.org/ben-biddington/richard_iii.png)](http://travis-ci.org/ben-biddington/richard_iii)

Based on [HTTP/1.1](http://www.w3.org/Protocols/rfc2616/rfc2616-sec5.html)

Here's what we'd like to be able to write about any restful microservice:

```
describe "An end-to-end example" do
  it "lets me see raw text" do
    when_I_request <<-TEXT 
      GET /1.1/statuses
      Host: api.twitter.com
      Accept: application/json
    TEXT

   then_I_get <<-REPLY 
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

  private

  def when_I_request(text)
    fail "Not implemented"
  end

  def then_I_get(what)
    fail "Not implemented"
  end
end
```
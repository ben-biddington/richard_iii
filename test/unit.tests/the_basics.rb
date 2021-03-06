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

  it "can be executed as a function, too" do
    spy_internet = SpyInternet.new

    text = <<-TEXT 
      POST /1.1/statuses/update
      Host: api.twitter.com
      Accept: application/json
      Content-type: application/x-www-form-urlencoded

      status=Who%20says%20famine%20has%20to%20be%20depressing?
    TEXT

    Richard::III.exec({:internet => spy_internet}, text)

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

  # TEST: quotes are treated literally
  # TEST: whitespace does not matter
  # TEST: where does it read the protocol part (HTTP or HTTPS)
  # TEST: looks like you can either supply absolute uri, or relative AND Host header
end

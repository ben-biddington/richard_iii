require 'minitest/autorun'
require 'minitest/pride'

module Richard
  module Internal
    class RequestLineParser
      
    end

    class RequestLine
      attr_reader :method, :uri
      
      def initialize(opts = {})
        @method,@uri = opts[:method],opts[:uri]
      end

      def eql?(other)
        return self.method == other.method && self.uri == other.uri
      end
    end
  end
end

module Richard
  class III
    def initialize(opts={})
      @internet = opts[:internet] || fail("You need to supply :internet")
    end

    def exec(text)
      lines = text.lines.map(&:chomp)

      verb = lines.first.match(/^(\w+)/)[1]
      path = lines.first.match(/(\S+)$/)[1]
      host = lines[1].match(/Host: (.+)$/)[1]

      @internet.execute Request.new(:verb => verb, :uri => "https://#{host}#{path}")
    end
  end
end

class Request
  attr_reader :verb, :uri

  def initialize(opts={})
    @verb,@uri = opts[:verb],opts[:uri]
  end

  def eql?(other)
    self.verb.eql?(other.verb) && self.uri.eql?(other.uri)
  end
end

describe 'The basics of Richard III' do
  it "can issue a very simple request" do
    spy_internet = MiniTest::Mock.new

    spy_internet.expect :execute, nil do |actual|
      actual.first.eql? Request.new(:verb => 'GET', :uri => 'https://api.twitter.com/1.1/statuses')
    end

    richard_iii = Richard::III.new :internet => spy_internet

    richard_iii.exec <<-TEXT 
GET /1.1/statuses
Host: api.twitter.com
Accept: application/json
    TEXT

    spy_internet.verify
  end

  # TEST: where does it read the protocol part (HTTP of HTTPS)
end

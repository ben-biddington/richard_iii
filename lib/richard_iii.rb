dir = File.join(File.dirname(__FILE__))

$LOAD_PATH.unshift File.join(dir, 'richard_iii')

Dir.glob(File.join(dir, "richard_iii", "**", "*.rb")).each {|f| require f}

module Richard
  module Internal
    class BasicRequestLineParser
      class << self
        def from(text)
          lines = text.lines.map(&:chomp).map(&:strip)

          verb = lines.first.match(/^(\w+)/)[1]
          path = lines.first.match(/(\S+)$/)[1]
          host = lines[1].match(/Host: (.+)$/)[1]

          RequestLine.new(verb, "https://#{host}#{path}")
        end
      end
    end

    RequestLine = Struct.new 'RequestLine', :verb, :uri
  end
end

module Richard
  class III
    def initialize(opts={})
      @internet = opts[:internet] || fail("You need to supply :internet")
    end

    def exec(text)
      request_line = Richard::Internal::BasicRequestLineParser.from text

      @internet.execute Request.new(:verb => request_line.verb, :uri => request_line.uri)
    end
  end

  class Request
    attr_reader :verb, :uri, :headers

    def initialize(opts={})
      @verb,@uri,@headers = opts[:verb],opts[:uri],opts[:headers]
    end

    def eql?(other)
      self.verb.eql?(other.verb) && self.uri.eql?(other.uri) && self.headers.eql?(other.headers)
    end
  end
end

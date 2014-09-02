module Richard; end

dir = File.join(File.dirname(__FILE__))

$LOAD_PATH.unshift File.join(dir, 'richard_iii')

Dir.glob(File.join(dir, "richard_iii", "**", "*.rb")).each {|f| require f}

module Richard
  class III
    def initialize(opts={})
      @internet = opts[:internet] || fail("You need to supply :internet")
    end

    def exec(text)
      request_line = request_line_from text

      reply = @internet.execute(
        Richard::Request.new(
          :verb     => request_line.verb, 
          :uri      => request_line.uri,
          :headers  => headers_from(text),
          :body     => body_from(text)
        )
      )

      Internal::CurlFormat.as_string reply
    end

    private
    
    def request_line_from(text)
      Richard::Internal::BasicRequestLineParser.from text, headers_from(text)
    end

    def headers_from(text)
      result = {}

      Internal::BasicHeaderParser.from(text).each{|h| result[h.name] = h.value }

      result
    end

    def body_from(text)
      Internal::BasicBodyParser.from(text)
    end
  end
end

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
        Request.new(
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
      Richard::Internal::BasicRequestLineParser.from text
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

  class Request
    attr_reader :verb, :uri, :headers, :body

    def initialize(opts={})
      @verb,@uri,@headers,@body = opts[:verb],opts[:uri],opts[:headers],opts[:body]
    end

    def eql?(other)
      self.verb.eql?(other.verb) && self.uri.eql?(other.uri) && self.headers == other.headers && self.body.eql?(other.body)
    end
  end

  class Response
    attr_reader :status, :headers, :body

    def initialize(opts={})
      @status,@headers,@body = opts[:status],opts[:headers],opts[:body]
    end

    def eql?(other)
      self.status.eql?(other.status) && self.headers == other.headers && self.body.eql?(other.body)
    end

    def each_header(&block)
      self.headers.each_pair{|k,v| block.call(k,v)}
    end
  end

  Status = Struct.new 'Status', :code, :desc do 
    def to_s; "#{code} #{desc}"; end
  end
end

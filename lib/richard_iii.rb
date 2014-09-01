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

    class BasicHeaderParser
      class << self
        def from(text)
          lines = text.lines.map(&:chomp).map(&:strip)
          lines.drop(1).take_while{|line| !line.strip.empty?}.map do |line|
            name,value = line.split(':')
            RequestHeader.new name.strip, value.strip
          end
        end
      end
    end

    class BasicBodyParser
      class << self
        def from(text)
          lines = text.lines.map(&:chomp).map(&:strip)
          lines.drop_while{|line| !line.strip.empty?}.drop(1).first
        end
      end
    end

    class CurlFormat
      class << self
        def as_string(reply)
          return '' if reply.nil?
          (
            ["HTTP/1.1 #{reply.status}"] + 
            headers_from(reply) + 
            ["\n#{reply.body.strip}\n"]
          ).join("\n")
        end

        private

        def headers_from(reply)
          reply.headers.map do |name, value|
            "#{name}: #{value}"
          end.to_a
        end
      end
    end
    
    RequestLine   = Struct.new 'RequestLine'  , :verb, :uri
    RequestHeader = Struct.new 'RequestHeader', :name, :value
  end
end

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

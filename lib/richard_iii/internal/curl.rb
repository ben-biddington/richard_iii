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
          CurlReply.new((
            ["HTTP/1.1 #{reply.status}"] + 
            headers_from(reply) + 
            ["\n#{reply.body.strip}\n"]
          ).join("\n"))
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

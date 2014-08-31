dir = File.join(File.dirname(__FILE__))

$LOAD_PATH.unshift File.join(dir, 'richard_iii')

Dir.glob(File.join(dir, "richard_iii", "**", "*.rb")).each {|f| require f}

module Richard
  class III
    def initialize(opts={})
      @internet = opts[:internet] || fail("You need to supply :internet")
    end

    def exec(text)
      lines = text.lines.map(&:chomp).map(&:strip)

      verb = lines.first.match(/^(\w+)/)[1]
      path = lines.first.match(/(\S+)$/)[1]
      host = lines[1].match(/Host: (.+)$/)[1]

      @internet.execute Request.new(:verb => verb, :uri => "https://#{host}#{path}")
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
end

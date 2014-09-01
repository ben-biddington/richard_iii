module Richard
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

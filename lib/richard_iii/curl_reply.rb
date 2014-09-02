module Richard
  class CurlReply
    def initialize(text)
      @text = text
    end

    def matches?(expected)
      actual_lines   = trim(@text)
      expected_lines = trim(expected)
        
      return (actual_lines & expected_lines).size.eql? expected_lines.size
    end

    def eql?(text)
      trim(@text).eql? trim(text)
    end

    def equals?(text); self.eql? text; end
    def ==(text); self.eql? text; end

    def to_s; @text; end
    def inspect; to_s; end

    private
    
    def trim(text)
      text.lines.map(&:chomp).map(&:strip)
    end
  end
end

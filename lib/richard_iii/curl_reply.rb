module Richard
  class CurlReply
    attr_reader :missing

    def initialize(text)
      @text = text
      @missing = []
    end

    def matches?(expected)
      actual_lines   = trim(@text)
      
      expected_lines = trim(expected)
      
      intersection = (actual_lines & expected_lines)

      @missing = expected_lines - intersection
  
      return intersection.size.eql? expected_lines.size
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

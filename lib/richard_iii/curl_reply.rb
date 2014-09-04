module Richard
  class CurlReply
    attr_reader :missing, :surplus

    def initialize(text)
      @text = text
      @missing = @surplus = []
    end

    def matches?(expected)
      actual_lines   = trim(@text)
      
      expected_lines = trim(expected)
      
      intersection = (actual_lines & expected_lines)

      @missing = (expected_lines - intersection).map{|it| it.text}
      @surplus = (actual_lines - expected_lines).map{|it| it.text}

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
      convert_all text.lines.map(&:chomp).map(&:strip)
    end

    def convert_all(lines=[])
      lines.map{|text| Richard::Internal::TextLine.new(text)}
    end
  end
end

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
      text.lines.map(&:chomp).map(&:strip).map{|text| Richard::Internal::TextLine.new(text)}
    end
  end
end

module Richard
  module Internal
    class TextLine
      attr_reader :text
      
      def initialize(text)
        @text = text || fail("You need to supply some text even if it's empty")
      end

      def hash; @text.hash; end

      def eql?(other_line)
        self.text.eql? other_line.text
      end

      def to_s; self.text; end
    end
  end
end

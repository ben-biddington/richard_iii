module Richard
  class CurlReply
    attr_reader :missing, :surplus

    def initialize(text)
      @text = text
      @missing = @surplus = []
    end

    def matches?(expected)
      actual_lines   = strip(@text)
      
      expected_lines = parse(expected)
      
      matches = actual_lines.select do |line|
        expected_lines.any?{|it| it.matches?(line)}
      end

      expectations_that_did_not_match_anything = expected_lines.select do |expected|
        actual_lines.none?{|line| expected.matches?(line)}
      end

      intersection = (actual_lines & matches)

      @missing = expectations_that_did_not_match_anything.map(&:text)
      @surplus = actual_lines - matches

      return intersection.size.eql? expected_lines.size
    end

    def eql?(text)
      strip(@text).eql? strip(text)
    end

    def equals?(text); self.eql? text; end
    def ==(text); self.eql? text; end

    def to_s; @text; end
    def inspect; to_s; end

    private
   
    def parse(text)
      convert_all strip(text)
    end

    def strip(text)
      text.lines.map(&:chomp).map(&:strip)
    end

    def convert_all(lines=[])
      lines.map do |text| 
        Richard::Internal::TextLine.new(text)
      end
    end
  end
end

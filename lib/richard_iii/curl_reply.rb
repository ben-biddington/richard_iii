module Richard
  class CurlReply
    attr_reader :missing, :surplus

    def initialize(text)
      @text = text
      @missing = @surplus = []
      @pretty = false
    end

    def use_pretty_xml
      @pretty = true;
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

      @missing = expectations_that_did_not_match_anything.map(&:text)
      @surplus = actual_lines - matches

      return matches.size.eql? expected_lines.size
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
      format(text).map(&:chomp).map(&:strip)
    end
    
    def format(text)
      return text.lines unless @pretty
     
      lines = text.lines.to_a
      
      body = lines.delete_at(lines.size-1)

      lines += Richard::Internal::XmlFormat.pretty(body)

      lines
    end

    def convert_all(lines=[])
      lines.map do |text| 
        text.start_with?("/") ? Richard::Internal::PatternLine.new(text) : Richard::Internal::TextLine.new(text)
      end
    end
  end
end

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

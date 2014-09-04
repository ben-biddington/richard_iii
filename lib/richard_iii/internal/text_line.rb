module Richard
  module Internal
    class TextLine
      attr_reader :text
      
      def initialize(text)
        @text = text || fail("You need to supply some text even if it's empty")
      end

      def matches?(text)
        @text.eql?(text)
      end
    end
  end
end

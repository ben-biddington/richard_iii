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

    class PatternLine
      attr_reader :text
      
      def initialize(text)
        @text = text || fail("You need to supply some text even if it's empty")
      end

      # [!] expects lines to start and end with /
      def matches?(text)
        regex = Regexp.new(@text.slice(1,(@text.size-2)))
        false == regex.match(text).nil?
      end
    end
  end
end

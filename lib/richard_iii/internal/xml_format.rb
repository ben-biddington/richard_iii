module Richard
  module Internal
    class XmlFormat 
      class << self
        def pretty(text)
          require 'nokogiri'
    
          doc = Nokogiri.XML(text) do |config|
            config.default_xml.noblanks
          end

          doc.to_xml(:indent => 2).lines.drop(1)
        end
      end
    end
  end
end

require File.join '.', 'test', 'helper'

describe "Matching pretty-formatted bodies" do
  before do
    @curl_reply = CurlReply.new <<-TEXT
      HTTP/1.1 200 OK
      Content-Type: text/xml; charset=utf-8

      <?xml version="1.0" encoding="utf-8"?><current><city id="6058560" name="London" /><humidity value="76" unit="%"/><pressure value="1018" unit="hPa"/></current>
    TEXT
  end

  it "matches when you have neither pretty formatted" do
    @curl_reply.must_match <<-TEXT
      HTTP/1.1 200 OK
      Content-Type: text/xml; charset=utf-8

      <?xml version="1.0" encoding="utf-8"?><current><city id="6058560" name="London" /><humidity value="76" unit="%"/><pressure value="1018" unit="hPa"/></current>
    TEXT
  end

  it "matches when you say yes to pretty bodies" do
    @curl_reply.use_pretty_xml
    @curl_reply.must_match <<-TEXT
      HTTP/1.1 200 OK
      Content-Type: text/xml; charset=utf-8

      <?xml version="1.0" encoding="utf-8"?>
      <current>
        <city id="6058560" name="London"/>
        <humidity value="76" unit="%"/>
        <pressure value="1018" unit="hPa"/>
      </current>
    TEXT
  end
end

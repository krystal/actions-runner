require 'spec_helper'

require 'nokogiri'

# test parsing some XML with Nokogiri
RSpec.describe 'XML parsing' do
  let(:raw_xml) do
    <<-XML
      <person>
        <name>John Doe</name>
        <age>27</age>
      </person>
    XML
  end

  it 'can parse an XML file' do
    xml = Nokogiri::XML(raw_xml)
    expect(xml.at_xpath('//name').text).to eq('John Doe')
  end
end

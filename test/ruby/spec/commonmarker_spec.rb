require 'spec_helper'

require 'commonmarker'

# test parsing some XML with Nokogiri
RSpec.describe 'commonmarker' do
  it 'can render markdown' do
    result = Commonmarker.to_html(
      'This is *bongos*, indeed.',
      options: { parse: { smart: true } }
    )

    expect(result).to eq("<p>This is <em>bongos</em>, indeed.</p>\n")
  end
end

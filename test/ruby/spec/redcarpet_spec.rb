require 'spec_helper'

require 'redcarpet'

# test parsing some XML with Nokogiri
RSpec.describe 'redcarpet' do
  let(:markdown) do
    Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      autolink: true, tables: true
    )
  end

  it 'can render markdown' do
    result = markdown.render('This is *bongos*, indeed.')

    expect(result).to eq("<p>This is <em>bongos</em>, indeed.</p>\n")
  end
end

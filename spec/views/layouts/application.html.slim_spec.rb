require 'rails_helper'

describe "layouts/application.html.slim" do
  it 'provides a link to the PGP public key' do
    render

    doc = Nokogiri::HTML(rendered)
    key = doc.css('link[rel="pgpkey"]').first

    expect(key).to_not be_nil
  end
end

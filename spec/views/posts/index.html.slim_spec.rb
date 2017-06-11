require 'rails_helper'

describe "posts/index.html.slim" do
  it 'provides email address with rel="me" attribute' do
    render

    doc = Nokogiri::HTML(rendered)
    all_rel_me = doc.css('a[rel="me"]')
    email = all_rel_me.find { |me| me[:href] == 'mailto:fra.boffa@gmail.com' }

    expect(email).to_not be_nil
  end
end

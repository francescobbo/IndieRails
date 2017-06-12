require 'rails_helper'

describe "posts/index.html.slim" do
  it 'provides email address with rel="me" attribute' do
    render

    doc = Nokogiri::HTML(rendered)
    all_rel_me = doc.css('a[rel="me"]')
    email = all_rel_me.find { |me| me[:href] == 'mailto:fra.boffa@gmail.com' }

    expect(email).to_not be_nil
  end

  it 'provides facebook link with rel="me" attribute' do
    render

    doc = Nokogiri::HTML(rendered)
    all_rel_me = doc.css('a[rel="me"]')
    facebook = all_rel_me.find { |me| me[:href] =~ /\Ahttps:\/\/www.facebook.com\// }

    expect(facebook).to_not be_nil
  end

  it 'provides twitter link with rel="me" attribute' do
    render

    doc = Nokogiri::HTML(rendered)
    all_rel_me = doc.css('a[rel="me"]')
    twitter = all_rel_me.find { |me| me[:href] =~ /\Ahttps:\/\/twitter.com\// }

    expect(twitter).to_not be_nil
  end

  it 'provides github link with rel="me" attribute' do
    render

    doc = Nokogiri::HTML(rendered)
    all_rel_me = doc.css('a[rel="me"]')
    github = all_rel_me.find { |me| me[:href] =~ /\Ahttps:\/\/github.com\// }

    expect(github).to_not be_nil
  end

  it 'provides keybase link with rel="me" attribute' do
    render

    doc = Nokogiri::HTML(rendered)
    all_rel_me = doc.css('a[rel="me"]')
    keybase = all_rel_me.find { |me| me[:href] =~ /\Ahttps:\/\/keybase.io\// }

    expect(keybase).to_not be_nil
  end
end

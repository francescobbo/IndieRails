xml.instruct! :xml, version: '1.0'
xml.tag! 'urlset', 'xmlns' => 'http://www.sitemaps.org/schemas/sitemap/0.9' do
  xml.url do
    xml.loc root_url
    xml.changefreq 'hourly'
  end

  posts.find_each do |post|
    xml.url do
      xml.loc post_url(post)
      xml.changefreq 'daily'
      xml.lastmod post.updated_at.strftime('%Y-%m-%d')
    end
  end
end

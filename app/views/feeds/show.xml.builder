xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0' do
  xml.channel do
    xml.title "Francesco Boffa"
    xml.author "Francesco Boffa"
    xml.description "Francesco Boffa's own web site"
    xml.link root_url
    xml.language "en"

    posts.each do |post|
      xml.item do
        xml.guid post.id
        xml.title post.title.presence || "Status Update #{l(post.created_at, format: :short)}"
        xml.author "Francesco Boffa"
        xml.pubDate post.published_at.to_s
        xml.link post_url(post)

        xml.description truncate(post.text_body, separator: ' ', omission: '...', length: 500)

        if post.main_medium
          xml.image do
            xml.url post.main_medium.file.url(:large)
            xml.title post.main_medium.default_alt
            xml.link post_url(post)
          end
        end
      end
    end
  end
end

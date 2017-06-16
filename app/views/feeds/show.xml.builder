xml.instruct! :xml, version: '1.0'
xml.rss version: '2.0', 'xmlns:webfeeds' => 'http://webfeeds.org/rss/1.0' do
  xml.channel do
    xml.title 'Francesco Boffa'
    xml.author 'Francesco Boffa'
    xml.description "Francesco Boffa's own web site"
    xml.link root_url
    xml.tag!('webfeeds:related', nil, layout: 'card', target: 'browser')
    xml.tag!('webfeeds:analytics', nil, engine: 'GoogleAnalytics', id: 'UA-101170237-1')
    xml.language 'en'

    posts.each do |post|
      xml.item do
        xml.guid post.id
        xml.title post.title.presence || "Status Update #{l(post.created_at, format: :short)}"
        xml.author 'Francesco Boffa'
        xml.pubDate post.published_at.to_s
        xml.link post_url(post)

        text = '<p>' + truncate(post.text_body, separator: ' ', omission: '[...]', length: 1000) + '</p>'
        if post.main_medium
          text = safe_join([image_tag(post.main_medium.file.url(:large)), text.html_safe])
        end

        xml.description text

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

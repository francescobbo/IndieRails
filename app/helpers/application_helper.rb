module ApplicationHelper
  def blog_jsonld
    {
      "@context": "http://schema.org",
      "@type": "Blog",
      "name": Settings.site_name,
      "url": "https://francescoboffa.com",
      "description": "My ramblings about AWS, Ruby and Tech in general. I'm getting AWS certified!",
      "sameAs": [
        "https://twitter.com/frboffa",
        "https://www.linkedin.com/in/francescoboffa/",
        "https://www.facebook.com/fr.boffa"
      ]
    }
  end

  def post_jsonld(post)
    data = {
      "@context": "https://schema.org",
      "@type": "BlogPosting",
      "headline": post.title,
      "description": post.meta_description,
      "datePublished": post.published_at.iso8601,
      "datemodified": post.updated_at.iso8601,
      "mainEntityOfPage": "True",
      "author": {
        "@type": "Person",
        "name": "Francesco Boffa",
        "url": "https://francescoboffa.com"
      },
      "publisher": {
        "@type": "Organization",
        "name": Settings.site_name,
        "logo": {
          "@type": "imageObject",
          "url": asset_url('logo.png')
        }
      },
      "articleBody": post.rendered_body
    }

    if post.main_medium
      data["image"] = {
        "@type": "imageObject",
        "url": post.main_medium.file.url(:large),
        "width": post.main_medium.width,
        "height": post.main_medium.height
      }
    end

    data
  end

  def embed_signup(body)
    if body =~ /<p>\[inline-signup\]<\/p>/
      body.gsub(/<p>\[inline-signup\]<\/p>/, render(partial: 'subscribe_inline'))
    else
      body
    end
  end
end

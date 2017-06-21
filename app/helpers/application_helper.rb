module ApplicationHelper
  def default_meta_tags
    {
      viewport: 'width=device-width,minimum-scale=1,initial-scale=1',
      site: 'Francesco Boffa',
      reverse: true,
      separator: '|'
    }
  end

  def blog_jsonld
    {
      "@context": "http://schema.org",
      "@type": "Blog",
      "name": "Francesco Boffa",
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
        "@type": "Person",
        "name": "Francesco Boffa",
        "url": "https://francescoboffa.com"
      },
      "articleBody": post.rendered_body
    }

    if post.main_medium
      data["image"] = {
        "@type": "imageObject",
        "url": post.main_medium.file.url(:large),
      }
    end

    data
  end
end

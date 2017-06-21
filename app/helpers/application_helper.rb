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
end

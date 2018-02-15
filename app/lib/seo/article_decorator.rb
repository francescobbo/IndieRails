module Seo
  class ArticleDecorator
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::AssetUrlHelper

    def initialize(article)
      @article = article
    end

    def meta
      base = {
        title: @article.title,
        description: @article.meta_description,
        article: {
          section: 'Technology',
          published_time: @article.published_at.iso8601,
          modified_time: @article.updated_at.iso8601
        }
      }

      base.merge!(twitter_metas) if Settings.social.twitter_username
      base.merge!(facebook_metas) if Settings.social.facebook_app_id
      base
    end

    def jsonld
      data = {
        '@id': article_url(@article),
        '@context': 'https://schema.org',
        '@type': 'BlogPosting',
        headline: @article.title,
        description: @article.meta_description,
        datePublished: @article.published_at.iso8601,
        dateModified: @article.updated_at.iso8601,
        mainEntityOfPage: 'True',
        author: {
          '@type': "Person",
          name: "Francesco Boffa",
          url: Settings.site_name
        },
        publisher: {
          '@type' => "Organization",
          name: Settings.site_name,
          logo: {
            '@type' => "imageObject",
            url: asset_url('logo.png')
          }
        },
        articleBody: @article.rendered_body
      }
    end

    private

    def twitter_metas
      {
        twitter: {
          card: 'summary',
          site: Settings.social.twitter_username,
          title: @article.title,
          description: @article.meta_description,
          domain: Settings.host,
          image: @article.main_medium&.file&.url(:large)
        }
      }
    end

    def facebook_metas
      {
        fb: {
          app_id: Settings.social.facebook_app_id
        },
        og: {
          title: @article.title,
          description: @article.meta_description,
          image: @article.main_medium&.file&.url(:large),
          url: article_url(@article),
          site_name: Settings.site_name,
          locale: I18n.locale,
          type: 'article'
        }
      }
    end
  end
end

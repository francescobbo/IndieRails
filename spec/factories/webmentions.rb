FactoryGirl.define do
  factory :webmention do
    outbound false
    source 'https://someweb.site/123'
    target 'https://francescoboffa.com/my-page'
    status :created

    post
  end
end

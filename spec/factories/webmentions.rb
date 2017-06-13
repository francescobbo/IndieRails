FactoryGirl.define do
  factory :webmention do
    outbound false
    source 'MyText'
    target 'MyText'
    status 1
    post_id 1
  end
end

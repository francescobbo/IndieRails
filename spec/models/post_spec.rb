require 'rails_helper'

RSpec.describe Post, type: :model do
  context 'when the body is changed' do
    it 'renders body as markdown' do
      post = Post.new
      post.body = '_hello_ **world**'
      expect(post.rendered_body.strip).to eq '<p><em>hello</em> <strong>world</strong></p>'
    end
  end

  context 'when the kind is note' do
    subject { FactoryGirl.build(:post, kind: :note) }
    it { is_expected.to validate_presence_of(:body) }
  end

  context 'when the kind is article' do
    subject { FactoryGirl.build(:post, kind: :article) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
  end

  describe '#deliver_webmentions' do
    it 'sends webmentions to urls referenced in the post body' do
      post = Post.new(body: 'https://www.google.com', kind: :note)
      post.save

      expect_any_instance_of(WebmentionClient).to receive(:deliver).with(anything, 'https://www.google.com')

      post.deliver_webmentions
    end

    it 'saves a Webmention object for every webmentioned url' do
      post = Post.new(body: 'https://www.google.com', kind: :note)
      post.save

      allow_any_instance_of(WebmentionClient).to receive(:deliver).with(anything, 'https://www.google.com')

      expect do
        post.deliver_webmentions
      end.to change { Webmention.count }.by 1
    end

    it 'saves the webmention status endpoint when the response is 201' do
      post = Post.new(body: 'https://www.google.com', kind: :note)
      post.save

      response = double(code: '201')
      allow(response).to receive(:[]).and_return 'http://status.com'
      allow_any_instance_of(WebmentionClient).to receive(:deliver).with(anything, 'https://www.google.com') { response }

      post.deliver_webmentions

      webmention = Webmention.last
      expect(webmention.status_endpoint).to eq 'http://status.com'
    end
  end
end

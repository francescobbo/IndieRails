require 'rails_helper'

RSpec.describe Webmention, type: :model do
  context 'when the webmention is outbound' do
    context 'when the source url is from the site domain' do
      it 'accepts the source' do
        webmention = Webmention.new(source: 'https://francescoboffa.com', outbound: true)
        webmention.valid?

        expect(webmention.errors[:source]).to be_empty
      end
    end

    context 'when the source url is not from the site domain' do
      it 'does not accept the source' do
        webmention = Webmention.new(source: 'https://facebook.com', outbound: true)
        webmention.valid?

        expect(webmention.errors[:source]).to_not be_empty
      end
    end

    context 'when the target url is to the site domain' do
      it 'does not accept the target' do
        webmention = Webmention.new(target: 'https://francescoboffa.com', outbound: true)
        webmention.valid?

        expect(webmention.errors[:target]).to_not be_empty
      end
    end

    context 'when the target url is not to the site domain' do
      it 'accepts the target' do
        webmention = Webmention.new(target: 'https://facebook.com', outbound: true)
        webmention.valid?

        expect(webmention.errors[:target]).to be_empty
      end
    end
  end

  context 'when the webmention is inbound' do
    context 'when the source url is from the site domain' do
      it 'does not accept the source' do
        webmention = Webmention.new(source: 'https://francescoboffa.com', outbound: false)
        webmention.valid?

        expect(webmention.errors[:source]).to_not be_empty
      end
    end

    context 'when the source url is not from the site domain' do
      it 'accepts the source' do
        webmention = Webmention.new(source: 'https://facebook.com', outbound: false)
        webmention.valid?

        expect(webmention.errors[:source]).to be_empty
      end
    end

    context 'when the target url is to the site domain' do
      it 'accepts the target' do
        webmention = Webmention.new(target: 'https://francescoboffa.com', outbound: false)
        webmention.valid?

        expect(webmention.errors[:target]).to be_empty
      end
    end

    context 'when the target url is not to the site domain' do
      it 'does not accept the target' do
        webmention = Webmention.new(target: 'https://facebook.com', outbound: false)
        webmention.valid?

        expect(webmention.errors[:target]).to_not be_empty
      end
    end
  end
end

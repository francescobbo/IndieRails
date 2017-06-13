require 'rails_helper'

RSpec.describe DeliverWebmentionsJob, type: :job do
  describe '#perform' do
    it 'calls deliver_webmentions on the post' do
      post = double
      expect(post).to receive(:deliver_webmentions)

      subject.perform(post)
    end
  end
end

require 'rails_helper'

describe SitemapsController do
  describe '#show' do
    it 'responds with OK (200)' do
      get :show
      expect(response).to be_successful
    end
  end
end

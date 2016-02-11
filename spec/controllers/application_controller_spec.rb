require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller(ApplicationController) { def index; end }

  context 'success' do
    before do
      authenticate_with_http_digest { get :index }
    end

    it { expect(response).to have_http_status(:success) }
  end

  context 'unauthorized' do
    before { get :index }

    it { expect(response).to have_http_status(:unauthorized) }
    it { expect(json_response).to eq 'status' => 'unauthorized' }
  end
end

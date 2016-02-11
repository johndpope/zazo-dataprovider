require 'rails_helper'

RSpec.describe 'invalid requests', type: :request do
  context 'not found' do
    before do
      authenticate_with_http_digest { get '/not_found', {}, @env }
    end

    it { expect(response).to have_http_status(:not_found) }
    it { expect(json_response).to eq 'errors' => 'invalid route: not_found' }
  end
end

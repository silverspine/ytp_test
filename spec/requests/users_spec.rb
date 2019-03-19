require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:admin) { create(:user, admin: true) }
  let(:users) { create_list(:user, 5) }
  let(:user) { users.first }
  let(:user_id) { user.id }
  let(:headers) { valid_headers }
  let(:admin_headers) {{
      "Authorization" => token_generator(admin.id), "Content-Type" => "application/json"
    }}

  # Test suite for GET /users/
  describe 'GET /users/' do
    context 'The user is an admin' do
      before { get "/users/", params: {}, headers: admin_headers }

      it 'returns status code 200' do
        byebug
        expect(response).to have_http_status(200)
      end

      it 'returns all users' do
        expect(json.size).to eq(6)
      end
    end

    context 'when user is not an admin' do
      before { get "/users/", params: {}, headers: headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns only displays the current user' do
        expect(json.size).to eq(1)
      end
    end
  end

end

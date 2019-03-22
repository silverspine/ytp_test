require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  let(:admin) { create(:user, admin: true) }
  let!(:users) { create_list(:user, 5) }
  let(:user) { users.first }
  let(:user_id) { user.id }
  let(:headers) { admin_headers }

  # Test suite for GET /users/
  describe 'GET /users/' do
    before { get "/users/", params: {}, headers: headers }

    context 'The user is an admin' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns all users' do
        expect(json.size).to eq(6)
      end
    end

    context 'when user is not an admin' do
      let(:headers) { valid_headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns only displays the current user' do
        expect(json["id"]).to eq(user.id)
      end
    end
  end

  # Test suite for POSY /users/
  describe 'POST /users/' do
    let(:valid_params) { { name: 'Cool name', email: 'cool@mail.com',
      password: 'sekret' }.to_json }
    before { post "/users/", params: valid_params, headers: headers }

    context 'Creates a new user with valid params' do
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'return the new user' do
        expect(json['email']).to eq('cool@mail.com')
      end

      it 'has an account' do
        expect(json['accounts'].size).to eq(1)
      end
    end

    context 'Creates a new admin' do
      let(:valid_params) { { name: 'Cool admin', email: 'cool@admin.com',
      password: 'sekret', admin: true }.to_json }
      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'is an admin' do
        expect(User.find(json['id'].to_i).admin).to eq(true)
      end

      it 'doesn\'t has an account' do
        expect(json['accounts'].size).to eq(0)
      end
    end

    context 'when the email is already taken' do
      let(:valid_params) { { name: 'Cool name', email: user.email,
      password: 'sekret' }.to_json }
      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Email has already been taken/)
      end
    end

    context 'when params are invalid' do
      let(:valid_params) { {} }
      it 'returns status code 201' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body)
          .to match(/Validation failed: Password can't be blank, Name can't be blank, Email can't be blank, Password digest can't be blank/)
      end
    end

    context 'when the user is not an admin' do
      let(:headers) { valid_headers }
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns an unauthorized failure message' do
        expect(response.body)
          .to match(/Unauthorized request/)
      end
    end
  end

  # Test suite for GET /users/:id
  describe 'GET /users/:id' do
    before { get "/users/#{user_id}", params: {}, headers: headers }

    context 'returns a user' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'is not empty' do
        expect(json['id']).to eq(user_id)
      end
    end

    context 'a user search himself' do
      let(:headers) { valid_headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'is not empty' do
        expect(json['id']).to eq(user_id)
      end

      it 'is not admin' do
        expect(User.find(json['id']).admin).to be(false)
      end
    end

    context 'a user search for someone else' do
      let(:headers) { valid_headers }
      let(:user_id) { users.last.id }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns an unauthorized failure message' do
        expect(response.body)
          .to match(/Unauthorized request/)
      end
    end
  end
end

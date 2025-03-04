require 'rails_helper'

RSpec.describe "Authentication", type: :request do
  let(:user) { create(:user, password: "password123") }
  let(:valid_credentials) { { email: user.email, password: "password123" } }
  let(:invalid_credentials) { { email: user.email, password: "wrongpassword" } }

  describe "POST /api/v1/auth/login" do
    it "logs in with valid credentials and returns a token" do
      post "/api/v1/auth/login", params: valid_credentials
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include("token")
    end

    it "rejects invalid credentials" do
      post "/api/v1/auth/login", params: invalid_credentials
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)).to include("error")
    end
  end

  describe "POST /api/v1/auth/sign_up" do
    let(:new_user) { { email: "newuser@example.com", password: "password123" } }

    it "registers a new user and returns a token" do
      post "/api/v1/auth/sign_up", params: new_user
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include("token")
    end
  end
end

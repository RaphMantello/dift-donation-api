# README
# Donations API

Ruby on Rails API for handling user donations with JWT authentication.

## Features
- User authentication (JWT-based)
- Create and track donations
- Retrieve total donations for a user

## Installation & Setup
- Install dependencies: bundle install
- Set DB up: rails db:create db:migrate db:seed
- Run server: rails s

## Endpoints
### Authentication
- Register a new user: POST  /api/v1/auth/register
- Login & get a JWT token: POST  /api/v1/auth/login

All requests need a valid JWT token to be included in the headers as follows:
"Authorization: Bearer YOUR_JWT_TOKEN"
The token is returned on valid registration / connection

### Donations
- Create a new donation: POST  /api/v1/donations
- Get total donation amount: GET /api/v1/donations/user_total

## Tests
- Running the test suite: bundle exec rspec

## cURL commands for manual tests
### Register
`curl -X POST http://localhost:3000/api/v1/auth/sign_up \
     -H "Content-Type: application/json" \
     -d '{
           "email": "newuser@example.com",
           "password": "password123"
         }'
`

### Login
`curl -X POST http://localhost:3000/api/v1/auth/login \
     -H "Content-Type: application/json" \
     -d '{
           "email": "newuser@example.com",
           "password": "password123"
         }'
`

### Donation#create (replace JWT token with result from registration/connection)
`curl -X POST http://localhost:3000/api/v1/donations \
     -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{
           "donation": {
             "amount_cents": 5000,
             "currency": "EUR",
             "project_id": 1
           }
         }'
`

### Donation#user_total (replace JWT token with result from registration/connection)
`curl -X GET http://localhost:3000/api/v1/donations/user_total \
     -H "Authorization: Bearer YOUR_JWT_TOKEN" \
     -H "Content-Type: application/json" \
     -d '{ "currency": "EUR" }'
`

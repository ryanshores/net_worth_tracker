# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration
```bash
touch .env
echo 'PLAID_CLIENT_ID=your_client_id' >> .env
echo 'PLAID_SECRET=your_secret' >> .env
echo 'PLAID_ENV=sandbox' >> .env
```

* Database creation
install postgresql 
install redis

* Database initialization
`bin/rails db:create`

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


## License
MIT — see LICENSE

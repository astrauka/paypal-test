# README

Application which tests how future payments authorization works

```
bundle install
bundle exec rake db:create db:migrate
bundle exec rails s
```

Go to http://localhost:3000

## Production

http://paypal-test.herokuapp.com/

Make a payment:

```
curl -H "Accept: application/json" -H "Content-Type: application/json" --data '{"user_id": 1, "correlation_id": 2}' http://paypal-test.herokuapp.com/payments
```

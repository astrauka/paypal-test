PayPal::SDK.load("config/paypal.yml", Rails.env)
PayPal::SDK.logger = Rails.logger

PayPal::SDK::Core::Config.load('config/paypal.yml',  ENV['RACK_ENV'] || 'development')

PayPal::SDK::REST.set_config(
  PayPal::SDK::Core::Config.send(:read_configurations)[Rails.env]
)

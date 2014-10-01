class PayPalApi
  attr_reader :user_id

  def initialize(user_id)
    @user_id = user_id
  end

  def future_authentication
    Rails.logger.info user_id
    @future_authentication ||= PayPalAuthentication.for_user_id(user_id).first
  end

  def future_authentication_code
    Rails.logger.info future_authentication.inspect
    future_authentication.code
  end

  def access_token
    @access_token ||= PayPal::SDK::REST::FuturePayment.exch_token(future_authentication_code)
  end

  def create_payment(correlation_id)
    payment = PayPal::SDK::REST::FuturePayment.new(future_payment_attributes(token: access_token))
    payment.create(correlation_id)
    payment
  end

  def future_payment_attributes(params)
    {
      intent: "authorize",
      payer: {
        payment_method: "paypal"
      },
      transactions: [
        {
          amount: {
            total: "1.00",
            currency: "USD"
          },
          description: "#{user.name} made a payment."
        }
      ]
    }.merge(params)
  end

  def user
    @user ||= User.find(user_id)
  end
end
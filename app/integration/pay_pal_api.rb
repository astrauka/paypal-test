class PayPalApi
  def self.config
    PayPal::SDK::Core::Config.send(:read_configurations)[Rails.env]
  end

  attr_reader :user_id

  def initialize(user_id)
    @user_id = user_id
  end

  def future_authentication
    @future_authentication ||= PayPalAuthentication.for_user_id(user_id).first
  end

  def retrieve_refresh_token
    Rails.logger.info "##### \n Retrieving refresh token \n"
    result = PayPal::SDK::Core::API::REST.new.token_hash(future_authentication.code)
    result[:refresh_token]
  end

  def access_token
    Rails.logger.info "##### \n Retrieving access token \n"
    @access_token ||=
      PayPal::SDK::OpenIDConnect::DataTypes::Tokeninfo
       .create_from_refresh_token(future_authentication.refresh_token)
       .access_token
  end

  def create_payment(correlation_id)
    payment = PayPal::SDK::REST::FuturePayment.new(future_payment_attributes(token: access_token))

    Rails.logger.info "##### \n Creating future payment \n"
    payment.create(correlation_id)

    payment.transactions.each do |transaction|
      transaction.related_resources.each do |related_resource|
        capture(related_resource.authorization)
      end
    end

    payment
  end

  def capture(authorization)
    Rails.logger.info "##### \n Capturing payment \n"
    result = authorization.capture(capture_attributes(token: access_token))
    if result.success?
      Rails.logger.info("CAPTURE success #{result.links.first.href}")
    else
      Rails.logger.warn("CAPTURE failure #{result.links.first.href}")
    end
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
      ],
    }.merge(params)
  end

  def capture_attributes(params)
    {
      amount:{
        currency:"USD",
        total:"1.00"
      },
      is_final_capture:true,
    }.merge(params)
  end

  def user
    @user ||= User.find(user_id)
  end
end
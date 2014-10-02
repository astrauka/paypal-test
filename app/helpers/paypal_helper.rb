module PaypalHelper
  def paypal_authorize_future_payments_url
    PayPal::SDK::Core::OpenIDConnect.authorize_url(
      redirect_uri: store_scope_pages_url,
      scope: [
        'email',
        'address',
        'profile',
        'https://uri.paypal.com/services/payments/futurepayments',
      ].join(' ')
    )
  end
end

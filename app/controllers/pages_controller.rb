class PagesController < ApplicationController
  def home
  end

  def store_scope
    @authentication = PayPalAuthentication.new(paypal_auth_params)
    if @authentication.save
      redirect_to success_pages_url
    else
      redirect_to error_pages_url
    end
  end

  private

  def paypal_auth_params
    params.permit(:scope, :code)
  end
end
class PagesController < ApplicationController
  expose(:authentication) { PayPalAuthentication }
  expose(:user_id) { 1 }
  expose(:pay_pal_api) { PayPalApi.new(user_id)}

  def home
  end

  def store_scope
    PayPalAuthentication.for_user_id(user_id).delete_all

    self.authentication = PayPalAuthentication.new(paypal_auth_params.merge(user_id: user_id))
    if authentication.save
      authentication.update_attribute(:refresh_token, pay_pal_api.retrieve_refresh_token)
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
class PagesController < ApplicationController
  expose(:authentication) { PayPalAuthentication }
  expose(:user_id) { 1 }
  expose(:pay_pal_api) { PayPalApi.new(user_id)}
  expose(:user) { User.find(user_id) }

  def home
  end

  def store_scope
    PayPalAuthentication.for_user_id(user_id).delete_all

    self.authentication = PayPalAuthentication.new(paypal_auth_params.merge(user_id: user_id))
    if authentication.save
      store_refresh_token
      store_user_info
      redirect_to success_pages_url
    else
      redirect_to error_pages_url
    end
  end

  private

  def store_refresh_token
    authentication.update_attribute(:refresh_token, pay_pal_api.refresh_token)
  end

  def paypal_auth_params
    params.permit(:scope, :code)
  end

  def store_user_info
    info = pay_pal_api.user_info
    user.email = info.email
    user.address = info.address.to_hash
    user.save
  end
end
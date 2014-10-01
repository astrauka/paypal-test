class PaymentsController < ApplicationController
  protect_from_forgery except: :create
  respond_to :json

  expose(:pay_pal_api) { PayPalApi.new(params[:user_id]) }

  def create
    begin
      payment = pay_pal_api.create_payment(params[:correlation_id])
    rescue PayPal::SDK::Core::Exceptions::ConnectionError => e
      Rails.logger.info e.message
      render status: :unauthorized, nothing: true
    else
      if payment.success?
        render status: :ok, nothing: true
      else
        render status: :not_acceptable, nothing: true
      end
    end
  end
end

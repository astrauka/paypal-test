class PaymentsController < ApplicationController
  respond_to :json

  expose(:pay_pal_api) { PayPalApi.new(params[:user_id]) }

  def create
    payment = pay_pal_api.create_payment(params[:correlation_id])
    if payment.success?
      respond_with status: :ok
    else
      respond_with status: :not_acceptable
    end
  end
end

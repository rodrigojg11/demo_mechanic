class PaymentsController < ApplicationController
  def show
    @payment = Payment.find_signed!(payment_params.fetch(:signed_id), purpose: :checkout)
    @appointment = @payment.appointment
  rescue ActiveSupport::MessageVerifier::InvalidSignature, ActiveRecord::RecordNotFound, KeyError
    redirect_to root_path, alert: "This payment link is invalid or expired.", allow_other_host: false
  end

  private

  def payment_params
    params.permit(:signed_id)
  end
end

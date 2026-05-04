class StripeWebhooksController < ApplicationController
  skip_forgery_protection only: :create

  def create
    processed = Payments::StripeWebhookService.new(
      payload: request.raw_post,
      signature: request.headers["Stripe-Signature"]
    ).process!

    processed ? head(:ok) : head(:bad_request)
  end
end

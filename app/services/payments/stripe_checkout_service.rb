module Payments
  class StripeCheckoutService
    CHECKOUT_HOST = "cruzauto.local"

    def initialize(payment)
      @payment = payment
    end

    def prepare!
      payment.update!(
        provider: "stripe",
        status: "optional_pending",
        checkout_url: checkout_url
      )
    end

    private

    attr_reader :payment

    def checkout_url
      Rails.application.routes.url_helpers.payment_checkout_url(
        signed_id: payment.signed_checkout_id,
        host: CHECKOUT_HOST
      )
    end
  end
end

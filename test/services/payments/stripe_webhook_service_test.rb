require "test_helper"

class Payments::StripeWebhookServiceTest < ActiveSupport::TestCase
  test "marks payment as paid advance on completed checkout" do
    payment = prepared_stripe_payment
    payload = stripe_payload(payment: payment, checkout_id: "cs_complete")

    assert Payments::StripeWebhookService.new(payload: payload, signature: "").process!
    assert_equal "paid_advance", payment.reload.status
    assert_equal "cs_complete", payment.external_id
  end

  test "rejects invalid signature when secret is configured" do
    payment = prepared_stripe_payment
    payload = stripe_payload(payment: payment, checkout_id: "cs_rejected")
    ENV["STRIPE_WEBHOOK_SECRET"] = "whsec_test"

    assert_not Payments::StripeWebhookService.new(payload: payload, signature: "t=#{Time.current.to_i},v1=bad").process!
    assert_equal "optional_pending", payment.reload.status
  ensure
    ENV.delete("STRIPE_WEBHOOK_SECRET")
  end

  private

  def prepared_stripe_payment
    AppointmentPaymentService.new(create_appointment(payment_preference: "pay_now")).prepare!
  end

  def stripe_payload(payment:, checkout_id:)
    {
      type: "checkout.session.completed",
      data: {
        object: {
          id: checkout_id,
          metadata: {
            payment_id: payment.signed_webhook_id
          }
        }
      }
    }.to_json
  end
end

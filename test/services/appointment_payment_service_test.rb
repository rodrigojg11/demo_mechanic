require "test_helper"

class AppointmentPaymentServiceTest < ActiveSupport::TestCase
  test "prepares manual optional payment when customer pays after service" do
    appointment = create_appointment(payment_preference: "pay_after_service")

    payment = AppointmentPaymentService.new(appointment).prepare!

    assert_equal "manual", payment.provider
    assert_equal "optional_pending", payment.status
    assert_nil payment.checkout_url
  end

  test "prepares Stripe optional payment when customer pays now" do
    appointment = create_appointment(payment_preference: "pay_now")

    payment = AppointmentPaymentService.new(appointment).prepare!

    assert_equal "stripe", payment.provider
    assert_equal "optional_pending", payment.status
    assert_match %r{/payments/.+/checkout}, payment.checkout_url
  end
end

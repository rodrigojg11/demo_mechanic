require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  test "validates approved states" do
    payment = Payment.new(provider: "stripe", status: "pending", amount_cents: 100, currency: "usd")

    assert_not payment.valid?
    assert_includes payment.errors[:status], "is not included in the list"
  end

  test "marks advance payment as paid" do
    payment = create_appointment(payment_preference: "pay_now").create_payment!(
      provider: "stripe",
      status: "optional_pending",
      amount_cents: 4_500,
      currency: "usd"
    )

    payment.mark_paid_advance!(external_id: "cs_test")

    assert_equal "paid_advance", payment.status
    assert_equal "cs_test", payment.external_id
    assert_not_nil payment.paid_at
  end
end

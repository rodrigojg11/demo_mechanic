class AppointmentPaymentService
  def initialize(appointment)
    @appointment = appointment
  end

  def prepare!
    payment = appointment.payment || appointment.build_payment(base_attributes)

    if appointment.payment_preference == "pay_now"
      prepare_stripe_payment(payment)
    else
      prepare_manual_payment(payment)
    end

    payment.save!
    Payments::StripeCheckoutService.new(payment).prepare! if payment.pay_now?
    payment.reload
  end

  private

  attr_reader :appointment

  def base_attributes
    {
      amount_cents: appointment.service.price_cents,
      currency: "usd"
    }
  end

  def prepare_stripe_payment(payment)
    payment.assign_attributes(
      provider: "stripe",
      status: "optional_pending",
      amount_cents: appointment.service.price_cents,
      currency: "usd"
    )
  end

  def prepare_manual_payment(payment)
    payment.assign_attributes(
      provider: "manual",
      status: "optional_pending",
      checkout_url: nil,
      amount_cents: appointment.service.price_cents,
      currency: "usd"
    )
  end
end

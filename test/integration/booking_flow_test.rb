require "test_helper"

class BookingFlowTest < ActionDispatch::IntegrationTest
  test "creates appointment without requiring advance payment" do
    service = create_service(slug: "booking-flow-oil")

    post appointments_path,
      params: {
        appointment_request: appointment_params(service: service, payment_preference: "pay_after_service")
      },
      headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }

    assert_response :success
    appointment = Appointment.last
    assert_equal "pay_after_service", appointment.payment_preference
    assert_equal "manual", appointment.payment.provider
    assert_equal "optional_pending", appointment.payment.status
  end

  test "signed confirmation link confirms appointment and raw token is rejected" do
    appointment = create_appointment
    token = appointment.create_appointment_confirmation_token!

    get confirm_appointment_response_path(token.signed_response_id)

    assert_response :success
    assert_equal "customer_confirmed", appointment.reload.status

    get cancel_appointment_response_path(token.token)

    assert_response :gone
  end

  test "Stripe webhook marks checkout as paid advance" do
    payment = AppointmentPaymentService.new(create_appointment(payment_preference: "pay_now")).prepare!

    post stripe_webhook_path,
      params: {
        type: "checkout.session.completed",
        data: {
          object: {
            id: "cs_flow",
            metadata: {
              payment_id: payment.signed_webhook_id
            }
          }
        }
      }.to_json,
      headers: { "CONTENT_TYPE" => "application/json" }

    assert_response :success
    assert_equal "paid_advance", payment.reload.status
  end

  private

  def appointment_params(service:, payment_preference:)
    {
      service_slug: service.slug,
      scheduled_on: next_shop_time.to_date.iso8601,
      scheduled_time: next_shop_time.strftime("%H:%M"),
      payment_preference: payment_preference,
      name: "Booking Customer",
      phone: "2145550123",
      email: unique_email,
      make: "Honda",
      model: "Civic",
      year: 2021,
      notes: "Booking flow test"
    }
  end
end

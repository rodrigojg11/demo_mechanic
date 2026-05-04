class AppointmentResponsesController < ApplicationController
  before_action :set_token

  def confirm
    return render_unusable unless @token.usable?

    @token.appointment.update!(status: "customer_confirmed")
    CalendarEventService.new(@token.appointment).sync!
    render plain: "Appointment confirmed. Thank you."
  end

  def cancel
    return render_unusable unless @token.usable?

    @token.appointment.release!
    render plain: "Appointment cancelled. This time is now available again."
  end

  def reschedule
    return render_unusable unless @token.usable?

    @token.appointment.release!
    render plain: "Appointment released for rescheduling. Please request a new time."
  end

  private

  def set_token
    @token = AppointmentConfirmationToken.find_signed!(
      response_params.fetch(:token),
      purpose: :appointment_response
    )
  rescue ActiveSupport::MessageVerifier::InvalidSignature, ActiveRecord::RecordNotFound, KeyError
    render_unusable
  end

  def response_params
    params.permit(:token)
  end

  def render_unusable
    render plain: "This appointment link is no longer available.", status: :gone
  end
end

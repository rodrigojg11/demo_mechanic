class AppointmentsController < ApplicationController
  def availability
    permitted = availability_params
    service = Service.active.find_by!(slug: permitted.fetch(:service_slug))
    date = Date.iso8601(permitted.fetch(:date))

    render json: { slots: ShopAvailability.new(date: date, service: service).slots }
  rescue ArgumentError, ActiveRecord::RecordNotFound, KeyError
    render json: { slots: [] }, status: :unprocessable_entity
  end

  def create
    @services = Service.active.ordered.map(&:booking_payload)
    @appointment_request = AppointmentRequest.new(appointment_request_params)

    if @appointment_request.save
      render turbo_stream: turbo_stream.replace(
        "booking_form",
        partial: "appointments/success",
        locals: { appointment: @appointment_request.appointment }
      )
    else
      render turbo_stream: turbo_stream.replace(
        "booking_form",
        partial: "appointments/form",
        locals: { appointment_request: @appointment_request, services: @services }
      ), status: :unprocessable_entity
    end
  end

  def preview
    appointment_preview_params

    render json: { ok: true, message: "Appointment request received in demo mode." }
  end

  private

  def appointment_request_params
    params.require(:appointment_request).permit(
      :service_slug,
      :scheduled_on,
      :scheduled_time,
      :payment_preference,
      :name,
      :phone,
      :email,
      :make,
      :model,
      :year,
      :notes
    )
  end

  def appointment_preview_params
    params.require(:appointment).permit(
      :step,
      :serviceId,
      :date,
      :monthOffset,
      :slot,
      :done,
      form: %i[name phone email make model year notes]
    )
  end

  def availability_params
    params.permit(:service_slug, :date)
  end
end

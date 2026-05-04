class ShopAvailability
  SLOT_INTERVAL = 30.minutes

  attr_reader :date, :service

  def self.business_hours_for(time)
    case time.in_time_zone.wday
    when 0 then [nil, nil]
    when 6 then [8, 14]
    else [8, 18]
    end
  end

  def initialize(date:, service:)
    @date = date.to_date
    @service = service
  end

  def available?
    opening_hour.present? && !BlockedDate.blocked?(date)
  end

  def slots
    return [] unless available?

    slot_times.map do |starts_at|
      {
        time: starts_at.strftime("%I:%M %p"),
        label: starts_at.strftime("%-I:%M %p"),
        available: slot_available?(starts_at)
      }
    end
  end

  private

  def slot_times
    current = opens_at
    slots = []

    while current + service.duration_minutes.minutes <= closes_at
      slots << current
      current += SLOT_INTERVAL
    end

    slots
  end

  def slot_available?(starts_at)
    return false if starts_at <= Time.current

    candidate_end = starts_at + service.duration_minutes.minutes + service.buffer_minutes.minutes
    blocking_appointments.none? do |appointment|
      starts_at < appointment.blocking_end_at && candidate_end > appointment.scheduled_at
    end
  end

  def blocking_appointments
    @blocking_appointments ||= Appointment.blocking.includes(:service).where(
      scheduled_at: opens_at...closes_at
    )
  end

  def opens_at
    date.in_time_zone.change(hour: opening_hour, min: 0)
  end

  def closes_at
    date.in_time_zone.change(hour: closing_hour, min: 0)
  end

  def opening_hour
    hours.first
  end

  def closing_hour
    hours.last
  end

  def hours
    @hours ||= self.class.business_hours_for(date.in_time_zone)
  end
end

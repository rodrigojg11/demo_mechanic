class Appointment < ApplicationRecord
  STATUSES = %w[
    requested
    scheduled
    customer_confirmed
    customer_cancelled
    expired_unconfirmed
    completed
    no_show
  ].freeze

  BLOCKING_STATUSES = %w[requested scheduled customer_confirmed].freeze
  PAYMENT_PREFERENCES = %w[pay_now pay_after_service].freeze

  belongs_to :customer
  belongs_to :vehicle
  belongs_to :service
  has_one :appointment_confirmation_token, dependent: :destroy
  has_one :calendar_event, dependent: :destroy
  has_one :payment, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :status, inclusion: { in: STATUSES }
  validates :payment_preference, inclusion: { in: PAYMENT_PREFERENCES }
  validates :scheduled_at, presence: true
  validates :notes, length: { maximum: 1_000 }, allow_blank: true
  validate :scheduled_in_the_future
  validate :scheduled_during_business_hours
  validate :service_must_fit_business_hours
  validate :slot_must_be_available

  before_validation :set_default_status

  scope :blocking, -> { where(status: BLOCKING_STATUSES) }
  scope :upcoming, -> { where(arel_table[:scheduled_at].gteq(Time.current)) }

  def customer_confirmed?
    status == "customer_confirmed"
  end

  def cancelled_or_released?
    status.in?(%w[customer_cancelled expired_unconfirmed])
  end

  def end_at
    return unless scheduled_at && service

    scheduled_at + service.duration_minutes.minutes
  end

  def blocking_end_at
    return unless end_at && service

    end_at + service.buffer_minutes.minutes
  end

  def release!
    update!(status: "customer_cancelled").tap do
      payment&.cancel!
      CalendarEventService.new(self).cancel!
    end
  end

  def expire_unconfirmed!
    update!(status: "expired_unconfirmed").tap do
      payment&.cancel!
      CalendarEventService.new(self).cancel!
    end
  end

  private

  def set_default_status
    self.status ||= "requested"
  end

  def scheduled_in_the_future
    return if scheduled_at.blank?
    return if scheduled_at > Time.current

    errors.add(:scheduled_at, "must be in the future")
  end

  def scheduled_during_business_hours
    return if scheduled_at.blank?

    opening, closing = ShopAvailability.business_hours_for(scheduled_at)
    if opening.nil?
      errors.add(:scheduled_at, "is not available on Sundays")
      return
    end

    if BlockedDate.blocked?(scheduled_at.to_date)
      errors.add(:scheduled_at, "is not available on this date")
      return
    end

    local_time = scheduled_at.in_time_zone
    starts_at = local_time.change(hour: opening, min: 0)
    closes_at = local_time.change(hour: closing, min: 0)

    return if local_time >= starts_at && local_time < closes_at

    errors.add(:scheduled_at, "must be during shop hours")
  end

  def service_must_fit_business_hours
    return if scheduled_at.blank? || service.blank?

    opening, closing = ShopAvailability.business_hours_for(scheduled_at)
    return if opening.nil?

    local_time = scheduled_at.in_time_zone
    closes_at = local_time.change(hour: closing, min: 0)
    return if end_at <= closes_at

    errors.add(:scheduled_at, "does not leave enough time for the selected service")
  end

  def slot_must_be_available
    return if scheduled_at.blank? || service.blank?
    return if status.in?(%w[customer_cancelled expired_unconfirmed completed no_show])

    appointments = Appointment.arel_table
    overlapping = Appointment.blocking
      .includes(:service)
      .where.not(id: id)
      .where(appointments[:scheduled_at].lt(blocking_end_at))
      .any? { |appointment| appointment.blocking_end_at > scheduled_at }

    errors.add(:scheduled_at, "is already booked") if overlapping
  end
end

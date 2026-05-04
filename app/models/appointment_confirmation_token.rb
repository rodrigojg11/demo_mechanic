class AppointmentConfirmationToken < ApplicationRecord
  belongs_to :appointment

  has_secure_token :token

  validates :token, uniqueness: true
  validates :expires_at, presence: true

  before_validation :set_default_expiration, on: :create

  def usable?
    expires_at.future? && appointment.scheduled_at.future?
  end

  def mark_used!
    update!(used_at: Time.current)
  end

  def signed_response_id
    signed_id(purpose: :appointment_response, expires_in: response_ttl)
  end

  private

  def set_default_expiration
    self.expires_at ||= 48.hours.from_now
  end

  def response_ttl
    [expires_at - Time.current, 1.minute].max
  end
end

class CalendarEvent < ApplicationRecord
  PROVIDERS = %w[google apple outlook internal].freeze

  belongs_to :appointment

  validates :provider, inclusion: { in: PROVIDERS }
  validates :external_id, presence: true

  def cancelled?
    cancelled_at.present?
  end
end

class Payment < ApplicationRecord
  PROVIDERS = %w[manual stripe].freeze
  STATUSES = %w[optional_pending paid_advance paid_after_service failed refunded].freeze

  belongs_to :appointment

  validates :provider, inclusion: { in: PROVIDERS }
  validates :status, inclusion: { in: STATUSES }
  validates :amount_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :currency, presence: true, format: { with: /\A[a-z]{3}\z/ }

  def pending?
    optional_pending?
  end

  def optional_pending?
    status == "optional_pending"
  end

  def paid?
    paid_advance? || paid_after_service?
  end

  def paid_advance?
    status == "paid_advance"
  end

  def paid_after_service?
    status == "paid_after_service"
  end

  def failed?
    status == "failed"
  end

  def pay_now?
    provider == "stripe"
  end

  def amount
    amount_cents / 100.0
  end

  def signed_checkout_id
    signed_id(purpose: :checkout, expires_in: 7.days)
  end

  def signed_webhook_id
    signed_id(purpose: :stripe_webhook, expires_in: 30.days)
  end

  def cancel!
    return unless optional_pending?

    update!(status: "failed", cancelled_at: Time.current)
  end

  def mark_paid_advance!(external_id: nil)
    update!(
      status: "paid_advance",
      external_id: external_id.presence || self.external_id,
      paid_at: Time.current
    )
  end

  def mark_paid_after_service!
    update!(status: "paid_after_service", paid_at: Time.current)
  end

  def refunded?
    status == "refunded"
  end
end

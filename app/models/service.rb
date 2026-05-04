class Service < ApplicationRecord
  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :name) }

  validates :slug, :name, :description, presence: true
  validates :slug, uniqueness: true, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/ }
  validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }
  validates :buffer_minutes, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price_cents, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :position, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def price
    price_cents / 100
  end

  def booking_payload
    {
      id: slug,
      name: name,
      desc: description,
      duration: duration_minutes,
      buffer: buffer_minutes,
      price: price,
      popular: popular?
    }
  end
end

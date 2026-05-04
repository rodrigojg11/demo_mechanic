class Vehicle < ApplicationRecord
  belongs_to :customer
  has_many :appointments, dependent: :restrict_with_exception

  validates :make, :model, presence: true
  validates :make, :model, length: { maximum: 80 }
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: 2100 }, allow_nil: true

  def display_name
    [year, make, model].compact_blank.join(" ")
  end
end

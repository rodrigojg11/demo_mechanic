class Customer < ApplicationRecord
  has_many :vehicles, dependent: :destroy
  has_many :appointments, dependent: :restrict_with_exception

  normalizes :email, with: ->(email) { email.to_s.strip.downcase }
  normalizes :phone, with: ->(phone) { phone.to_s.gsub(/\D/, "") }

  validates :name, :phone, :email, presence: true
  validates :name, length: { maximum: 120 }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, length: { maximum: 254 }
  validates :phone, length: { minimum: 10, maximum: 15 }
end

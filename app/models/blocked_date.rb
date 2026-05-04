class BlockedDate < ApplicationRecord
  validates :date, presence: true, uniqueness: true
  validates :reason, length: { maximum: 120 }, allow_blank: true

  scope :upcoming, -> { where(arel_table[:date].gteq(Time.zone.today)).order(:date) }

  def self.blocked?(date)
    exists?(date: date)
  end
end

class AppointmentRequest
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :service_slug, :string
  attribute :scheduled_on, :string
  attribute :scheduled_time, :string
  attribute :payment_preference, :string, default: "pay_after_service"
  attribute :name, :string
  attribute :phone, :string
  attribute :email, :string
  attribute :make, :string
  attribute :model, :string
  attribute :year, :integer
  attribute :notes, :string

  PAYMENT_PREFERENCES = %w[pay_now pay_after_service].freeze

  validates :service_slug, :scheduled_on, :scheduled_time, :payment_preference, presence: true
  validates :name, :phone, :email, :make, :model, presence: true
  validates :name, length: { maximum: 120 }
  validates :email, length: { maximum: 254 }
  validates :phone, length: { minimum: 10, maximum: 24 }
  validates :make, :model, length: { maximum: 80 }
  validates :notes, length: { maximum: 1_000 }, allow_blank: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :payment_preference, inclusion: { in: PAYMENT_PREFERENCES }
  validates :year, numericality: { only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: 2100 }, allow_nil: true

  attr_reader :appointment

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      customer.save!
      vehicle.save!
      @appointment = Appointment.create!(
        customer: customer,
        vehicle: vehicle,
        service: service,
        scheduled_at: scheduled_at,
        notes: notes,
        payment_preference: payment_preference
      )
      AppointmentPaymentService.new(@appointment).prepare!
      CalendarEventService.new(@appointment).sync!
      AppointmentNotificationService.new(@appointment).enqueue_initial_notifications
    end

    true
  rescue ActiveRecord::RecordInvalid => error
    merge_record_errors(error.record)
    false
  end

  def service
    @service ||= Service.active.find_by(slug: service_slug).tap do |record|
      errors.add(:service_slug, "is not available") if record.nil?
    end
  end

  def scheduled_at
    return if scheduled_on.blank? || scheduled_time.blank?

    Time.zone.parse("#{scheduled_on} #{scheduled_time}")
  rescue ArgumentError
    errors.add(:scheduled_on, "is invalid")
    nil
  end

  private

  def customer
    @customer ||= Customer.find_or_initialize_by(email: email.to_s.strip.downcase).tap do |record|
      record.name = name
      record.phone = phone
    end
  end

  def vehicle
    @vehicle ||= customer.vehicles.find_or_initialize_by(
      make: make,
      model: model,
      year: year.presence
    )
  end

  def merge_record_errors(record)
    record.errors.full_messages.each { |message| errors.add(:base, message) }
  end
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  include ActiveJob::TestHelper

  self.use_transactional_tests = true

  setup do
    ActiveJob::Base.queue_adapter = :test
    ActionController::Base.allow_forgery_protection = false
    ApplicationController.allow_forgery_protection = false
  end

  teardown do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  def create_service(slug: unique_slug("oil"), duration_minutes: 60, buffer_minutes: 15, price_cents: 4_500)
    Service.create!(
      slug: slug,
      name: "Oil Change",
      description: "Synthetic oil and filter service.",
      duration_minutes: duration_minutes,
      buffer_minutes: buffer_minutes,
      price_cents: price_cents,
      active: true,
      position: 1
    )
  end

  def create_customer(email: unique_email)
    Customer.create!(
      name: "Test Customer",
      phone: "2145550100",
      email: email
    )
  end

  def create_vehicle(customer:)
    customer.vehicles.create!(
      make: "Toyota",
      model: "Camry",
      year: 2020
    )
  end

  def create_appointment(service: create_service, scheduled_at: next_shop_time, payment_preference: "pay_after_service")
    customer = create_customer
    vehicle = create_vehicle(customer: customer)

    Appointment.create!(
      customer: customer,
      vehicle: vehicle,
      service: service,
      scheduled_at: scheduled_at,
      payment_preference: payment_preference
    )
  end

  def next_shop_time(hour: 10)
    date = 3.days.from_now.to_date
    date += 1.day while date.sunday?
    Time.zone.local(date.year, date.month, date.day, hour, 0)
  end

  def unique_slug(prefix)
    "#{prefix}-#{SecureRandom.hex(4)}"
  end

  def unique_email
    "test-#{SecureRandom.hex(6)}@example.com"
  end
end

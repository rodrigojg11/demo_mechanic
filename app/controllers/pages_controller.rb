class PagesController < ApplicationController
  def home
    content = HomepageContent.new
    @business = content.business
    @mechanic = content.mechanic
    @services = Service.active.ordered.map(&:booking_payload)
    @appointment_request = AppointmentRequest.new
    @gallery = content.gallery
    @reviews = content.reviews
    @hours = content.hours
  end
end

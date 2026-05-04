module Payments
  class StripeWebhookService
    SIGNATURE_TOLERANCE = 5.minutes

    def initialize(payload:, signature:)
      @payload = payload.to_s
      @signature = signature.to_s
    end

    def process!
      return false unless verified?

      event = JSON.parse(payload)
      handle_checkout_completed(event) if event["type"] == "checkout.session.completed"
      true
    rescue JSON::ParserError
      false
    end

    private

    attr_reader :payload, :signature

    def handle_checkout_completed(event)
      session = event.dig("data", "object") || {}
      payment = find_payment(session)
      return if payment.nil?

      payment.mark_paid_advance!(external_id: session["id"])
    end

    def find_payment(session)
      by_external_id(session["id"]) || by_metadata(session.dig("metadata", "payment_id"))
    end

    def by_external_id(external_id)
      return if external_id.blank?

      Payment.find_by(external_id: external_id)
    end

    def by_metadata(signed_id)
      return if signed_id.blank?

      Payment.find_signed(signed_id, purpose: :stripe_webhook)
    end

    def verified?
      secret = webhook_secret
      return Rails.env.local? if secret.blank?

      timestamp, signatures = signature_parts
      return false if timestamp.blank? || signatures.empty?
      return false if Time.zone.at(timestamp.to_i) < SIGNATURE_TOLERANCE.ago

      expected = OpenSSL::HMAC.hexdigest("SHA256", secret, "#{timestamp}.#{payload}")
      signatures.any? { |value| ActiveSupport::SecurityUtils.secure_compare(value, expected) }
    end

    def signature_parts
      parts = signature.split(",").filter_map do |item|
        key, value = item.split("=", 2)
        [key, value] if key.present? && value.present?
      end

      [parts.assoc("t")&.last, parts.select { |key, _| key == "v1" }.map(&:last)]
    end

    def webhook_secret
      Rails.application.credentials.dig(:stripe, :webhook_secret).presence || ENV["STRIPE_WEBHOOK_SECRET"].presence
    end
  end
end

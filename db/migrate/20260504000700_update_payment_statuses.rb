class UpdatePaymentStatuses < ActiveRecord::Migration[7.2]
  def up
    Payment.where(status: %w[not_required pending]).update_all(status: "optional_pending")
    Payment.where(status: "paid").update_all(status: "paid_advance")
    Payment.where(status: "cancelled").update_all(status: "failed")
  end

  def down
    Payment.where(status: "optional_pending").update_all(status: "pending")
    Payment.where(status: %w[paid_advance paid_after_service]).update_all(status: "paid")
  end
end

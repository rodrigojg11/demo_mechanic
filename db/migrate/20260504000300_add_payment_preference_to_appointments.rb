class AddPaymentPreferenceToAppointments < ActiveRecord::Migration[7.2]
  def change
    add_column :appointments, :payment_preference, :string, null: false, default: "pay_after_service"
    add_index :appointments, :payment_preference
  end
end

class AddCoreBookingUniquenessConstraints < ActiveRecord::Migration[7.2]
  def change
    remove_index :appointment_confirmation_tokens, :appointment_id, if_exists: true
    remove_index :calendar_events, :appointment_id, if_exists: true

    add_index :appointment_confirmation_tokens, :appointment_id, unique: true
    add_index :calendar_events, :appointment_id, unique: true
  end
end

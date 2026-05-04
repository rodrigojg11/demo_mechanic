class AddCalendarEventPayloadAndCancellation < ActiveRecord::Migration[7.2]
  def change
    add_column :calendar_events, :ics_payload, :text
    add_column :calendar_events, :cancelled_at, :datetime
    add_index :calendar_events, :cancelled_at
  end
end

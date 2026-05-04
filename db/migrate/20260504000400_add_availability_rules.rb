class AddAvailabilityRules < ActiveRecord::Migration[7.2]
  def change
    add_column :services, :buffer_minutes, :integer, null: false, default: 15

    create_table :blocked_dates do |t|
      t.date :date, null: false
      t.string :reason
      t.timestamps
    end

    add_index :blocked_dates, :date, unique: true
  end
end

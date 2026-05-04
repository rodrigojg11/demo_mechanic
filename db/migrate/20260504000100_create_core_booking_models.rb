class CreateCoreBookingModels < ActiveRecord::Migration[7.2]
  def change
    create_table :customers do |t|
      t.string :name, null: false
      t.string :phone, null: false
      t.string :email, null: false
      t.timestamps
    end

    add_index :customers, :email
    add_index :customers, :phone

    create_table :vehicles do |t|
      t.references :customer, null: false, foreign_key: true
      t.string :make, null: false
      t.string :model, null: false
      t.integer :year
      t.string :vin
      t.timestamps
    end

    add_index :vehicles, :vin

    create_table :services do |t|
      t.string :slug, null: false
      t.string :name, null: false
      t.text :description, null: false
      t.integer :duration_minutes, null: false
      t.integer :price_cents, null: false, default: 0
      t.boolean :popular, null: false, default: false
      t.boolean :active, null: false, default: true
      t.integer :position, null: false, default: 0
      t.timestamps
    end

    add_index :services, :slug, unique: true
    add_index :services, %i[active position]

    create_table :appointments do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.references :service, null: false, foreign_key: true
      t.datetime :scheduled_at, null: false
      t.string :status, null: false, default: "requested"
      t.text :notes
      t.timestamps
    end

    add_index :appointments, :scheduled_at
    add_index :appointments, :status
    add_index :appointments, %i[scheduled_at status]

    create_table :appointment_confirmation_tokens do |t|
      t.references :appointment, null: false, foreign_key: true
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.datetime :used_at
      t.timestamps
    end

    add_index :appointment_confirmation_tokens, :token, unique: true

    create_table :notifications do |t|
      t.references :appointment, null: false, foreign_key: true
      t.string :channel, null: false
      t.string :status, null: false, default: "pending"
      t.string :recipient, null: false
      t.string :subject
      t.text :body
      t.datetime :scheduled_at
      t.datetime :sent_at
      t.text :error_message
      t.timestamps
    end

    add_index :notifications, :status
    add_index :notifications, :scheduled_at

    create_table :calendar_events do |t|
      t.references :appointment, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :external_id, null: false
      t.string :calendar_url
      t.datetime :synced_at
      t.timestamps
    end

    add_index :calendar_events, %i[provider external_id], unique: true
  end
end

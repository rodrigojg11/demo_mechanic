# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_05_04_000700) do
  create_table "appointment_confirmation_tokens", force: :cascade do |t|
    t.integer "appointment_id", null: false
    t.string "token", null: false
    t.datetime "expires_at", null: false
    t.datetime "used_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_appointment_confirmation_tokens_on_appointment_id", unique: true
    t.index ["token"], name: "index_appointment_confirmation_tokens_on_token", unique: true
  end

  create_table "appointments", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.integer "vehicle_id", null: false
    t.integer "service_id", null: false
    t.datetime "scheduled_at", null: false
    t.string "status", default: "requested", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_preference", default: "pay_after_service", null: false
    t.index ["customer_id"], name: "index_appointments_on_customer_id"
    t.index ["payment_preference"], name: "index_appointments_on_payment_preference"
    t.index ["scheduled_at", "status"], name: "index_appointments_on_scheduled_at_and_status"
    t.index ["scheduled_at"], name: "index_appointments_on_scheduled_at"
    t.index ["service_id"], name: "index_appointments_on_service_id"
    t.index ["status"], name: "index_appointments_on_status"
    t.index ["vehicle_id"], name: "index_appointments_on_vehicle_id"
  end

  create_table "blocked_dates", force: :cascade do |t|
    t.date "date", null: false
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_blocked_dates_on_date", unique: true
  end

  create_table "calendar_events", force: :cascade do |t|
    t.integer "appointment_id", null: false
    t.string "provider", null: false
    t.string "external_id", null: false
    t.string "calendar_url"
    t.datetime "synced_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "ics_payload"
    t.datetime "cancelled_at"
    t.index ["appointment_id"], name: "index_calendar_events_on_appointment_id", unique: true
    t.index ["cancelled_at"], name: "index_calendar_events_on_cancelled_at"
    t.index ["provider", "external_id"], name: "index_calendar_events_on_provider_and_external_id", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "name", null: false
    t.string "phone", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_customers_on_email"
    t.index ["phone"], name: "index_customers_on_phone"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "appointment_id", null: false
    t.string "channel", null: false
    t.string "status", default: "pending", null: false
    t.string "recipient", null: false
    t.string "subject"
    t.text "body"
    t.datetime "scheduled_at"
    t.datetime "sent_at"
    t.text "error_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_notifications_on_appointment_id"
    t.index ["scheduled_at"], name: "index_notifications_on_scheduled_at"
    t.index ["status"], name: "index_notifications_on_status"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "appointment_id", null: false
    t.string "provider", null: false
    t.string "status", null: false
    t.integer "amount_cents", default: 0, null: false
    t.string "currency", default: "usd", null: false
    t.string "checkout_url"
    t.string "external_id"
    t.datetime "paid_at"
    t.datetime "cancelled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["appointment_id"], name: "index_payments_on_appointment_id", unique: true
    t.index ["external_id"], name: "index_payments_on_external_id"
    t.index ["provider"], name: "index_payments_on_provider"
    t.index ["status"], name: "index_payments_on_status"
  end

  create_table "services", force: :cascade do |t|
    t.string "slug", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.integer "duration_minutes", null: false
    t.integer "price_cents", default: 0, null: false
    t.boolean "popular", default: false, null: false
    t.boolean "active", default: true, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "buffer_minutes", default: 15, null: false
    t.index ["active", "position"], name: "index_services_on_active_and_position"
    t.index ["slug"], name: "index_services_on_slug", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.integer "customer_id", null: false
    t.string "make", null: false
    t.string "model", null: false
    t.integer "year"
    t.string "vin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_vehicles_on_customer_id"
    t.index ["vin"], name: "index_vehicles_on_vin"
  end

  add_foreign_key "appointment_confirmation_tokens", "appointments"
  add_foreign_key "appointments", "customers"
  add_foreign_key "appointments", "services"
  add_foreign_key "appointments", "vehicles"
  add_foreign_key "calendar_events", "appointments"
  add_foreign_key "notifications", "appointments"
  add_foreign_key "payments", "appointments"
  add_foreign_key "vehicles", "customers"
end

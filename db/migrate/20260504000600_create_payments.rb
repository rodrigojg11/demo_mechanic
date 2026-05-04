class CreatePayments < ActiveRecord::Migration[7.2]
  def change
    create_table :payments do |t|
      t.references :appointment, null: false, foreign_key: true, index: { unique: true }
      t.string :provider, null: false
      t.string :status, null: false
      t.integer :amount_cents, null: false, default: 0
      t.string :currency, null: false, default: "usd"
      t.string :checkout_url
      t.string :external_id
      t.datetime :paid_at
      t.datetime :cancelled_at

      t.timestamps
    end

    add_index :payments, :provider
    add_index :payments, :status
    add_index :payments, :external_id
  end
end

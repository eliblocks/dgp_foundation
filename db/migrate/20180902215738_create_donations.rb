class CreateDonations < ActiveRecord::Migration[5.2]
  def change
    create_table :donations do |t|
      t.string :full_name
      t.string :email
      t.string :ip_address
      t.string :postal_code
      t.integer :amount
      t.string :source
      t.string :external_id
      t.references :cause, foreign_key: true

      t.timestamps
    end
  end
end

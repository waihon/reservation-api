class CreateGuests < ActiveRecord::Migration[6.1]
  def change
    create_table :guests do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :phone_1
      t.string :phone_2
      t.string :phone_3

      t.timestamps
    end
  end
end

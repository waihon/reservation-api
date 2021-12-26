class RenamePhoneOfGuests < ActiveRecord::Migration[6.1]
  def change
    rename_column :guests, :phone, :phone_1
  end
end

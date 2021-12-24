class RenameFieldsOfGuests < ActiveRecord::Migration[6.1]
  def change
    rename_column :guests, :phone_1, :phone
  end
end

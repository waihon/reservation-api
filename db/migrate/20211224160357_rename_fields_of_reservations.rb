class RenameFieldsOfReservations < ActiveRecord::Migration[6.1]
  def change
    rename_column :reservations, :code, :reservation_code
  end
end

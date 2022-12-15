class CreateZipCode < ActiveRecord::Migration[5.2]
  def change
    create_table :zip_codes do |t|
      t.string :zip1
      t.string :zip2

      t.timestamps null: false
    end
  end
end

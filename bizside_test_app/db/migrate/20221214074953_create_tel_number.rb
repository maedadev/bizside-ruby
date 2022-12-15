class CreateTelNumber < ActiveRecord::Migration[5.2]
  def change
    create_table :tel_numbers do |t|
      t.string :tel

      t.timestamps null: false
    end
  end
end

class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :url
      t.string :url_without_schema
      t.timestamps null: false
    end
  end
end

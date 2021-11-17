class CreateIpAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :ip_addresses do |t|
      t.string :ip_address_v4
      t.string :ip_address_cidr

      t.timestamps null: false
    end
  end
end

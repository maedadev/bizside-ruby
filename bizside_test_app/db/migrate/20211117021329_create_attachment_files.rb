class CreateAttachmentFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :attachment_files do |t|
      t.string :file, null: false
      t.string :original_filename
      t.timestamps
    end
  end
end

class CreateLinks < ActiveRecord::Migration[8.1]
  def change
    create_table :links do |t|
      t.string :name
      t.string :slug
      t.string :destination_url
      t.boolean :active
      t.datetime :expires_at
      t.integer :clicks_count

      t.timestamps
    end
    add_index :links, :slug, unique: true
  end
end

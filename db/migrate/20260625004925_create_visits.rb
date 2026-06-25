class CreateVisits < ActiveRecord::Migration[8.1]
  def change
    create_table :visits do |t|
      t.references :link, null: false, foreign_key: true
      t.string :ip_address
      t.text :user_agent
      t.text :referer
      t.string :country
      t.string :city
      t.string :device_type
      t.string :browser
      t.string :os
      t.boolean :bot
      t.datetime :visited_at

      t.timestamps
    end
  end
end

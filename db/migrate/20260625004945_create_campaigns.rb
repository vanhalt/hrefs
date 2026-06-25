class CreateCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :campaigns do |t|
      t.string :name
      t.string :source
      t.string :medium
      t.text :notes

      t.timestamps
    end
  end
end

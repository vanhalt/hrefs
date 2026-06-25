class CreateLinkCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :link_campaigns do |t|
      t.references :link, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end

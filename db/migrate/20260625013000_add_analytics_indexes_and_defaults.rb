class AddAnalyticsIndexesAndDefaults < ActiveRecord::Migration[8.1]
  def change
    change_column_default :links, :active, from: nil, to: true
    change_column_null :links, :active, false, true

    change_column_default :links, :clicks_count, from: nil, to: 0
    change_column_null :links, :clicks_count, false, 0

    change_column_default :visits, :bot, from: nil, to: false
    change_column_null :visits, :bot, false, false

    add_index :links, :active
    add_index :links, :expires_at
    add_index :links, :clicks_count

    add_index :visits, :visited_at
    add_index :visits, [ :link_id, :visited_at ]
  end
end

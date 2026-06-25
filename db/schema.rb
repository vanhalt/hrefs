# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_25_013000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "campaigns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "medium"
    t.string "name"
    t.text "notes"
    t.string "source"
    t.datetime "updated_at", null: false
  end

  create_table "link_campaigns", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.datetime "created_at", null: false
    t.bigint "link_id", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_link_campaigns_on_campaign_id"
    t.index ["link_id"], name: "index_link_campaigns_on_link_id"
  end

  create_table "links", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.integer "clicks_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "destination_url"
    t.datetime "expires_at"
    t.string "name"
    t.string "slug"
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_links_on_active"
    t.index ["clicks_count"], name: "index_links_on_clicks_count"
    t.index ["expires_at"], name: "index_links_on_expires_at"
    t.index ["slug"], name: "index_links_on_slug", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.boolean "bot", default: false, null: false
    t.string "browser"
    t.string "city"
    t.string "country"
    t.datetime "created_at", null: false
    t.string "device_type"
    t.string "ip_address"
    t.bigint "link_id", null: false
    t.string "os"
    t.text "referer"
    t.datetime "updated_at", null: false
    t.text "user_agent"
    t.datetime "visited_at"
    t.index ["link_id", "visited_at"], name: "index_visits_on_link_id_and_visited_at"
    t.index ["link_id"], name: "index_visits_on_link_id"
    t.index ["visited_at"], name: "index_visits_on_visited_at"
  end

  add_foreign_key "link_campaigns", "campaigns"
  add_foreign_key "link_campaigns", "links"
  add_foreign_key "sessions", "users"
  add_foreign_key "visits", "links"
end

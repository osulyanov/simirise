# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_03_140245) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "name"
    t.date "birth_date"
    t.string "phone"
    t.string "fb_link"
    t.string "position"
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "access", default: [], array: true
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.integer "timepad_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string "description_short"
    t.text "description_html"
    t.string "coordinates"
    t.string "fb_link"
    t.text "conditions"
    t.integer "access_status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "location", default: {}, null: false
    t.jsonb "questions", default: [], null: false
    t.integer "moderation_status", default: 0, null: false
    t.text "timepad_description"
    t.string "report_url"
  end

  create_table "line_ups", force: :cascade do |t|
    t.bigint "event_id"
    t.string "name"
    t.string "timing"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_line_ups_on_event_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "event_id"
    t.integer "timepad_id"
    t.jsonb "status"
    t.string "mail"
    t.jsonb "payment"
    t.string "promocodes", default: [], array: true
    t.jsonb "referrer"
    t.jsonb "meta"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "answers"
    t.datetime "imported_at"
    t.index ["event_id"], name: "index_orders_on_event_id"
    t.index ["imported_at"], name: "index_orders_on_imported_at"
  end

  create_table "performances", force: :cascade do |t|
    t.bigint "event_id"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_performances_on_event_id"
  end

  create_table "settings", force: :cascade do |t|
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags_users", id: false, force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "user_id", null: false
  end

  create_table "ticket_types", force: :cascade do |t|
    t.integer "timepad_id"
    t.bigint "event_id"
    t.string "name"
    t.string "description"
    t.integer "buy_amount_min"
    t.integer "buy_amount_max"
    t.integer "price"
    t.boolean "is_promocode_locked"
    t.integer "remaining"
    t.datetime "sale_ends_at"
    t.datetime "sale_starts_at"
    t.string "public_key"
    t.boolean "is_active"
    t.integer "ad_partner_profit"
    t.boolean "send_personal_links"
    t.integer "sold"
    t.integer "attended"
    t.integer "limit"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_ticket_types_on_event_id"
  end

  create_table "ticket_types_tickets", id: false, force: :cascade do |t|
    t.bigint "ticket_type_id", null: false
    t.bigint "ticket_id", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "ticket_type_id"
    t.integer "timepad_id"
    t.string "number"
    t.integer "price_nominal"
    t.jsonb "answers"
    t.jsonb "attendance"
    t.jsonb "place"
    t.jsonb "codes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.datetime "imported_at"
    t.index ["imported_at"], name: "index_tickets_on_imported_at"
    t.index ["order_id"], name: "index_tickets_on_order_id"
    t.index ["ticket_type_id"], name: "index_tickets_on_ticket_type_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.citext "email"
    t.date "birth_date"
    t.string "fb_link"
    t.string "phone"
    t.integer "state", default: 0, null: false
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "answers"
    t.string "source"
    t.string "fb_id"
    t.jsonb "messages"
    t.string "sms_code"
    t.datetime "smsed_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["fb_id"], name: "index_users_on_fb_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end

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

ActiveRecord::Schema.define(version: 20170626230813) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pgcrypto"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "media", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "file_file_name", null: false
    t.string "file_content_type", null: false
    t.integer "file_file_size", null: false
    t.datetime "file_updated_at", null: false
    t.text "default_alt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "width"
    t.integer "height"
  end

  create_table "posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug"
    t.boolean "deleted", default: false, null: false
    t.text "title"
    t.text "body"
    t.text "rendered_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "main_medium_id"
    t.boolean "draft", default: false, null: false
    t.datetime "published_at"
    t.text "reply_to"
    t.string "type", default: "Article", null: false
    t.text "meta_description"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_subscribers_on_email", unique: true
  end

  create_table "webmentions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "outbound", null: false
    t.text "source", null: false
    t.text "target", null: false
    t.integer "status", default: 0, null: false
    t.text "status_endpoint"
    t.uuid "post_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "kind", default: 0, null: false
    t.string "author_name"
    t.text "author_image"
    t.text "author_url"
    t.index ["source", "target", "outbound"], name: "index_webmentions_on_source_and_target_and_outbound", unique: true
  end

  add_foreign_key "posts", "media", column: "main_medium_id", on_delete: :restrict
  add_foreign_key "webmentions", "posts", on_delete: :cascade
end

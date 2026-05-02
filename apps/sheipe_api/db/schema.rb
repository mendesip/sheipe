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

ActiveRecord::Schema[8.1].define(version: 2026_05_02_120000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  create_table "exercises", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "category", null: false
    t.datetime "created_at", null: false
    t.uuid "creator_id"
    t.text "description"
    t.boolean "is_system", default: false, null: false
    t.string "muscle_group", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_exercises_on_category"
    t.index ["creator_id"], name: "index_exercises_on_creator_id"
    t.index ["is_system"], name: "index_exercises_on_is_system"
    t.index ["muscle_group"], name: "index_exercises_on_muscle_group"
  end

  create_table "sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "access_token", null: false
    t.datetime "access_token_expires_at", null: false
    t.datetime "created_at", null: false
    t.string "refresh_token", null: false
    t.datetime "refresh_token_expires_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["access_token"], name: "index_sessions_on_access_token", unique: true
    t.index ["refresh_token"], name: "index_sessions_on_refresh_token", unique: true
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text)", name: "index_users_on_lower_email", unique: true
  end

  add_foreign_key "exercises", "users", column: "creator_id"
  add_foreign_key "sessions", "users"
end

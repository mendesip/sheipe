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

ActiveRecord::Schema[8.1].define(version: 2026_05_02_120600) do
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

  create_table "routine_exercises", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "exercise_id", null: false
    t.text "notes"
    t.integer "position", null: false
    t.uuid "routine_id", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_routine_exercises_on_exercise_id"
    t.index ["routine_id", "position"], name: "index_routine_exercises_on_routine_id_and_position"
    t.index ["routine_id"], name: "index_routine_exercises_on_routine_id"
  end

  create_table "routine_sets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "reps"
    t.integer "rest_seconds"
    t.uuid "routine_exercise_id", null: false
    t.integer "set_number", null: false
    t.string "set_type", default: "working", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight", precision: 6, scale: 2
    t.index ["routine_exercise_id", "set_number"], name: "index_routine_sets_on_routine_exercise_id_and_set_number"
    t.index ["routine_exercise_id"], name: "index_routine_sets_on_routine_exercise_id"
  end

  create_table "routines", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "creator_id", null: false
    t.text "description"
    t.boolean "is_template", default: false, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_routines_on_creator_id"
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

  create_table "workout_exercises", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.uuid "exercise_id", null: false
    t.text "notes"
    t.integer "position", null: false
    t.uuid "routine_exercise_id"
    t.datetime "updated_at", null: false
    t.uuid "workout_id", null: false
    t.index ["exercise_id"], name: "index_workout_exercises_on_exercise_id"
    t.index ["routine_exercise_id"], name: "index_workout_exercises_on_routine_exercise_id"
    t.index ["workout_id", "position"], name: "index_workout_exercises_on_workout_id_and_position"
    t.index ["workout_id"], name: "index_workout_exercises_on_workout_id"
  end

  create_table "workout_sets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "completed", default: false, null: false
    t.datetime "created_at", null: false
    t.text "notes"
    t.integer "reps"
    t.decimal "rpe", precision: 3, scale: 1
    t.integer "set_number", null: false
    t.datetime "updated_at", null: false
    t.decimal "weight", precision: 6, scale: 2
    t.uuid "workout_exercise_id", null: false
    t.index ["workout_exercise_id", "set_number"], name: "index_workout_sets_on_workout_exercise_id_and_set_number"
    t.index ["workout_exercise_id"], name: "index_workout_sets_on_workout_exercise_id"
  end

  create_table "workouts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "finished_at"
    t.uuid "gym_id"
    t.text "notes"
    t.uuid "routine_id"
    t.datetime "started_at", null: false
    t.text "trainer_notes"
    t.datetime "updated_at", null: false
    t.uuid "user_id", null: false
    t.index ["routine_id"], name: "index_workouts_on_routine_id"
    t.index ["user_id", "started_at"], name: "index_workouts_on_user_id_and_started_at"
    t.index ["user_id"], name: "index_workouts_on_user_id"
  end

  add_foreign_key "exercises", "users", column: "creator_id"
  add_foreign_key "routine_exercises", "exercises"
  add_foreign_key "routine_exercises", "routines"
  add_foreign_key "routine_sets", "routine_exercises"
  add_foreign_key "routines", "users", column: "creator_id"
  add_foreign_key "sessions", "users"
  add_foreign_key "workout_exercises", "exercises"
  add_foreign_key "workout_exercises", "routine_exercises"
  add_foreign_key "workout_exercises", "workouts"
  add_foreign_key "workout_sets", "workout_exercises"
  add_foreign_key "workouts", "routines"
  add_foreign_key "workouts", "users"
end

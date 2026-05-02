class CreateRoutineSets < ActiveRecord::Migration[8.1]
  def change
    create_table :routine_sets, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :routine_exercise, type: :uuid, foreign_key: true, null: false
      t.integer :set_number, null: false
      t.decimal :weight, precision: 6, scale: 2
      t.integer :reps
      t.integer :rest_seconds
      t.string  :set_type, null: false, default: "working"

      t.timestamps
    end

    add_index :routine_sets, [ :routine_exercise_id, :set_number ]
  end
end

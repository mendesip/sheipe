class CreateWorkoutSets < ActiveRecord::Migration[8.1]
  def change
    create_table :workout_sets, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :workout_exercise, type: :uuid, foreign_key: true, null: false
      t.integer :set_number, null: false
      t.decimal :weight, precision: 6, scale: 2
      t.integer :reps
      t.decimal :rpe, precision: 3, scale: 1
      t.boolean :completed, null: false, default: false
      t.text    :notes

      t.timestamps
    end

    add_index :workout_sets, [ :workout_exercise_id, :set_number ]
  end
end

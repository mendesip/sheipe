class CreateWorkoutExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :workout_exercises, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :workout,  type: :uuid, foreign_key: true, null: false
      t.references :exercise, type: :uuid, foreign_key: true, null: false
      t.references :routine_exercise, type: :uuid, foreign_key: true, null: true
      t.integer :position, null: false
      t.text    :notes

      t.timestamps
    end

    add_index :workout_exercises, [ :workout_id, :position ]
  end
end

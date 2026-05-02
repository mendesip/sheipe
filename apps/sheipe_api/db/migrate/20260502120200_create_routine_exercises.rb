class CreateRoutineExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :routine_exercises, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :routine,  type: :uuid, foreign_key: true, null: false
      t.references :exercise, type: :uuid, foreign_key: true, null: false
      t.integer :position, null: false
      t.text    :notes

      t.timestamps
    end

    add_index :routine_exercises, [ :routine_id, :position ]
  end
end

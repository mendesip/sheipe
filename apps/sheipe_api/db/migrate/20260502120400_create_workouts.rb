class CreateWorkouts < ActiveRecord::Migration[8.1]
  def change
    create_table :workouts, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :user, type: :uuid, foreign_key: true, null: false
      t.references :routine, type: :uuid, foreign_key: true, null: true
      t.uuid :gym_id
      t.datetime :started_at, null: false
      t.datetime :finished_at, null: true
      t.text     :notes
      t.text     :trainer_notes

      t.timestamps
    end

    add_index :workouts, [ :user_id, :started_at ]
  end
end

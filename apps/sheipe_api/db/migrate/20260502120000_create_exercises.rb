class CreateExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :exercises, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string  :name, null: false
      t.text    :description
      t.string  :muscle_group, null: false
      t.string  :category, null: false
      t.boolean :is_system, null: false, default: false
      t.references :creator, type: :uuid, foreign_key: { to_table: :users }, null: true

      t.timestamps
    end

    add_index :exercises, :muscle_group
    add_index :exercises, :category
    add_index :exercises, :is_system
  end
end

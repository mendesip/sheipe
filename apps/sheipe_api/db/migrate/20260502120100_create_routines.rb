class CreateRoutines < ActiveRecord::Migration[8.1]
  def change
    create_table :routines, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.string  :name, null: false
      t.text    :description
      t.references :creator, type: :uuid, foreign_key: { to_table: :users }, null: false
      t.boolean :is_template, null: false, default: false

      t.timestamps
    end
  end
end

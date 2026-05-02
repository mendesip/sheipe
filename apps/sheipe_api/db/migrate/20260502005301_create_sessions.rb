class CreateSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :sessions, id: :uuid, default: "gen_random_uuid()" do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.string :access_token, null: false
      t.datetime :access_token_expires_at, null: false

      t.string :refresh_token, null: false
      t.datetime :refresh_token_expires_at, null: false

      t.timestamps
    end

    add_index :sessions, :access_token, unique: true
    add_index :sessions, :refresh_token, unique: true
  end
end

class CreateSessionSongs < ActiveRecord::Migration
  def self.up
    create_table :session_songs do |t|
      t.string :title, :limit => 250, :null => false
      t.string :performers, :limit => 300, :null => false
      t.string :authors, :limit => 300, :null => false
      t.datetime :session_datetime, :null => false
      t.integer :user_id, :null => false
      t.boolean :revised, :null => false, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :session_songs
  end
end

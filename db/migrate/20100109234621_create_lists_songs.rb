class CreateListSongs < ActiveRecord::Migration
  def self.up
    create_table :lists_songs, :primary_key =>[:list_id, :song_id] do |t|
      t.datetime  :session_datetime, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :lists_songs
  end
end

class AddIndexToSessionTimeColumnInSessionSongsTable < ActiveRecord::Migration
  def self.up
    add_index :session_songs, :session_datetime, :unique => false
  end

  def self.down
    remove_index :session_songs, :session_datetime
  end
end

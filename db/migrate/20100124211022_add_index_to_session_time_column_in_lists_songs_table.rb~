class AddIndexToSessionTimeColumnInListsSongsTable < ActiveRecord::Migration
  def self.up
    add_index :lists_songs, :session_datetime, :unique => true
  end

  def self.down
    remove_index :lists_songs, :session_datetime
  end
end

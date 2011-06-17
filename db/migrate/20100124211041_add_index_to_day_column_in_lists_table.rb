class AddIndexToDayColumnInListsTable < ActiveRecord::Migration
  def self.up
    add_index :lists, :day, :unique => true
  end

  def self.down
    remove_index :lists, :day
  end
end

class RemoveSongsColumns < ActiveRecord::Migration
  def self.up
    remove_column:songs, :author_id, :performer_id
  end

  def self.down
    add_column :songs, :author_id, :integer, :null => false
    add_column :songs, :performer_id, :integer, :null => false
  end
end

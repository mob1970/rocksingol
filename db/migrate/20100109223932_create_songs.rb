class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string    :name, :limit => 200, :null => false
      t.integer   :author_id, :null => false
      t.integer   :performer_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end

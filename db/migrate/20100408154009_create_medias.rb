class CreateMedias < ActiveRecord::Migration
  def self.up
    create_table :medias do |t|
      t.string  :code, :limit => 500
      t.string  :url,  :limit => 500
      t.integer :media_type_id, :null => false
      t.integer :song_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :medias
  end
end

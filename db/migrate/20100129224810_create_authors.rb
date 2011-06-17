class CreateAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors, :primary_key => [:song_id, :band_id] do |t|
      t.integer	:song_id,	:null => false
      t.integer	:band_id,	:null => false
    end
  end

  def self.down
    drop_table :authors
  end
end

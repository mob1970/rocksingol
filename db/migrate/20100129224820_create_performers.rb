class CreatePerformers < ActiveRecord::Migration
  def self.up
    create_table :performers, :primary_key => [:song_id, :band_id] do |t|
      t.integer	:song_id,	:null => false
      t.integer	:band_id,	:null => false
    end
  end

  def self.down
    drop_table :performers
  end
end

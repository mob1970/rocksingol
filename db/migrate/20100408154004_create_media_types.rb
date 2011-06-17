class CreateMediaTypes < ActiveRecord::Migration
  def self.up
    create_table :media_types do |t|
      t.string  :name, :limit => 100, :null => false
      t.string  :url,  :limit => 100
    end
  end

  def self.down
    drop_table :media_types
  end
end

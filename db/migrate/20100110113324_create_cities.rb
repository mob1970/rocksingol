class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.string :name, :limit => 100, :null => false
      t.string :frequency, :limit => 15, :null => true
      t.integer :province_id, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :cities
  end
end

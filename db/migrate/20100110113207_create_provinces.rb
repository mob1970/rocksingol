class CreateProvinces < ActiveRecord::Migration
  def self.up
    create_table :provinces do |t|
      t.string :name, :limit => 100, :null => false
      t.string :frequency, :limit => 15, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :provinces
  end
end

class CreateBands < ActiveRecord::Migration
  def self.up
    create_table :bands do |t|
      t.string :name, :limit => 150, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :bands
  end
end

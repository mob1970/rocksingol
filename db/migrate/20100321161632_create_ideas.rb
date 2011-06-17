class CreateIdeas < ActiveRecord::Migration
  def self.up
    create_table :ideas do |t|
      t.string  :title,       :limit => 50,   :null => false
      t.string  :description, :limit => 250,  :null => false
      t.integer :score,       :null => false, :default => 0
      t.boolean :done,        :null => false, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :ideas
  end
end

class CreatePeople < ActiveRecord::Migration
  def self.up
    create_table :people do |t|
      t.string :firstname, :limit => 100, :null => false
      t.string :lastname,  :limit => 100, :null => false
      t.string :nickname,  :limit => 50, :null => true
      t.string :web,      :limit => 150, :null => true
      t.string :blog,      :limit => 150, :null => true
      t.timestamps
    end
  end

  def self.down
    drop_table :people
  end
end

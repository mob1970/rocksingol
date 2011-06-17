class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
		t.string	:firstname,	:limit => 125,	:null => false
		t.string	:lastname,	:limit => 125,	:null => false
		t.string	:login,		:limit => 125,	:null => false
		t.string	:password,	:limit => 125,	:null => false
		t.string	:email,		:limit => 250,	:null => false
		t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

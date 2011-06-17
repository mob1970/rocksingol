class CreateLogins < ActiveRecord::Migration
  def self.up
    create_table :logins do |t|
      t.integer   :user_id, :null => false
      t.timestamp :login_datetime, :null => false
      t.timestamp :logout_datetime
    end
  end

  def self.down
    drop_table :logins
  end
end

class User < ActiveRecord::Base

  has_many :logins

  validates_presence_of :firstname
  validates_presence_of :lastname
  validates_presence_of :login
  validates_presence_of :password
  validates_presence_of :email

  validates_uniqueness_of :login

  ###
  #
  ###
  def self.number_of_visitors()
    return count_by_sql('select count(*) from sessions')
  end

end

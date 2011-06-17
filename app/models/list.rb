class List < ActiveRecord::Base

  has_many :list_songs
  has_many :songs, :through => :list_songs

  validates_presence_of :day

end

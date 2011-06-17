class Song < ActiveRecord::Base

  has_many :authors
  has_many :authors_list, :through => :authors, :source => :band

  has_many :performers
  has_many :performers_list, :through => :performers, :source => :band

  has_many :list_songs
  has_many :lists, :through => :list_songs

  has_many :medias

  validates_presence_of :name

end

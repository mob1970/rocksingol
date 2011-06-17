class MediaType < ActiveRecord::Base
  has_many :medias

  validates_presence_of :name
end

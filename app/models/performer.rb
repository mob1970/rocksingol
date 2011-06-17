class Performer < ActiveRecord::Base
  belongs_to :song
  belongs_to :band
  
  validates_presence_of :band_id
  validates_presence_of :song_id
end

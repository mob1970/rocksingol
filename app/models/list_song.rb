class ListSong < ActiveRecord::Base
  belongs_to :song
  belongs_to :list

  validates_presence_of :session_datetime

end

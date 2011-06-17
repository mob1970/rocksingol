class SessionSong < ActiveRecord::Base
  validates_presence_of :title
  validates_presence_of :performers
  validates_presence_of :authors
  validates_presence_of :session_datetime
end

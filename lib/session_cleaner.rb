require 'active_record'

class SessionCleaner
  def self.remove_stale_sessions
    ActiveRecord::SessionStore::Session.destroy_all(['updated_at < ?', 4.hours.ago])
  end
end
class Idea < ActiveRecord::Base

  validates_presence_of :title
  validates_presence_of :description


  ###
  #
  ###
  def voted()
    self.score += 1
    save()
  end

end

class Band < ActiveRecord::Base
  
  has_many :performers
  has_many :authors

  ###
  #
  ###
  def first_char_for_search()
    if (!name)
      return nil
    elsif (name.upcase()[0..3] == 'THE ')
      return name[4, 1].upcase()
    elsif (name.upcase()[0..3] == 'LOS ')
      return name[4, 1].upcase()
    elsif (name.upcase()[0..2] == 'LA ')
      return name[3, 1].upcase()
    else
      return name[0, 1].upcase()
    end
  end


  ###
  #
  ###
  def to_s()
    return self.name
  end

end

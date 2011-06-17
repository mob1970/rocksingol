class BandController < ApplicationController

  ###
  #
  ###
  def info()
    if (params[:band_id])
        #@songs = Performer.fin
    end
  end

  ###
  #
  ###
  def list()
    if (params[:first_char])
      case (params[:first_char])
        when 'L'
          @bands = Band.find(:all, :conditions => ["name like ? and name not like 'Los %' and name not like 'La %'", "#{params[:first_char]}%"], :order => 'name')
        when 'T'
          @bands = Band.find(:all, :conditions => ["name like ? and name not like 'The %'", "#{params[:first_char]}%"], :order => 'name')
        else
          @bands = Band.find(:all, :conditions => ["name like ? or name like ? or name like ? or name like ?", "#{params[:first_char]}%", "The #{params[:first_char]}%", "Los #{params[:first_char]}%", "La #{params[:first_char]}%"], :order => 'name')
      end
    end
  end

  ###
  #
  ###
  def songs()
    if (params[:band_id])
      @band = Band.find_by_id(params[:band_id], :order => 'name')
    end

    if (params[:session_date])
      @session_date = case params[:session_date] 
      	when String
      		{:day   => params[:session_date][6, 2],
      		 :month => params[:session_date][4, 2],
      		 :year  => params[:session_date][0, 4]}
      	when Hash
      		params[:session_date]
      end
    end

    if (params[:song_id])
      @song = Song.find_by_id(params[:song_id])
      if (!@band && @song.performers_list.length != 0)
        @band = @song.performers_list[0]
      end
    end
  end

end

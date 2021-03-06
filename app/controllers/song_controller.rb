class SongController < ApplicationController


  ###
  #
  ###
  def list_by_date()

    if (params[:date])
      @reference_date = Date.new(params[:date][:year].to_i(), params[:date][:month].to_i(), params[:date][:day].to_i())
    else
      @reference_date = Date.today()
      @title = 'Revision de las canciones que han sonado en el programa. Escoge el dia. '
      return
    end

    @title = "Revision de las canciones que han sonado en el programa del dia #{params[:date][:day]}/#{params[:date][:month]}/#{params[:date][:year]}"


    session_init_datetime = DateTime.new(@reference_date.year, @reference_date.month, @reference_date.day, 0, 0, 0)
    session_end_datetime  = DateTime.new(@reference_date.year, @reference_date.month, @reference_date.day, 23, 59, 59)

    @confirmed_songlist = ListSong.find(:all, :joins => :list, :conditions => ['day = ?', @reference_date], :order => 'session_datetime')
    #@unconfirmed_songlist = SessionSong.find(:all, :conditions => ['session_datetime between ? AND ? AND revised = ?', session_init_datetime, session_end_datetime, false], :order => 'session_datetime')
    @unconfirmed_songlist = SessionSong.find(:all, :conditions => ['session_datetime between ? AND ?', session_init_datetime, session_end_datetime], :order => 'session_datetime')

  end

  ###
  #
  ###
  def add_song()

    if (!session[:user_id])
      redirect_to :controller => 'session', :action => 'login'
      return
    end

    flash[:notice] = nil
    flash[:error]  = nil

    if (params && params[:song])
      if (!params[:song][:authors] || params[:song][:authors].length() == 0)
        params[:song][:authors] = params[:song][:performers]
      end

      params[:song][:session_datetime] = DateTime.new(params[:date][:year].to_i(), params[:date][:month].to_i(), params[:date][:day].to_i(),
                                                      params[:date][:hour].to_i(), params[:date][:minutes].to_i())
      
      params[:song][:user_id] = session[:user_id]

      song = SessionSong.new(params[:song])

      if (song.save())
        flash[:notice] = 'Canci&oacute;n a&ntilde;adida a la sesi&oacute;n de hoy.'
      else
        flash[:error] = 'Error a&ntilde;adiendo canci&oacute;n (revisa los datos).'
      end

    end

    if (params && params[:date])
      @reference_date = DateTime.new(params[:date][:year].to_i(), params[:date][:month].to_i(), params[:date][:day].to_i())
    else
      @reference_date = DateTime.now()
    end

    session_init_datetime = DateTime.new(@reference_date.year, @reference_date.month, @reference_date.day, 0, 0, 0)
    session_end_datetime  = DateTime.new(@reference_date.year, @reference_date.month, @reference_date.day, 23, 59, 59)
    @songlist = SessionSong.find(:all, :conditions => ['session_datetime between ? AND ?', session_init_datetime, session_end_datetime], :order => 'session_datetime')

    
    @title = 'a&ntilde;adiendo canciones a la sesi&oacute;n del dia ' + @reference_date.strftime("%d-%m-%Y")

  end

  ###
  #
  ###
  def add_media()
    if (params[:media])
      media = Media.create(params[:media])
      if (!media)
        flash[:error] = 'No se han a&ntilde;adido los datos a la canci&oacute;n'
      end
    end
    redirect_to :controller => 'band', :action => 'songs', :band_id => params[:band_id], :song_id => params[:media][:song_id]
  end

end

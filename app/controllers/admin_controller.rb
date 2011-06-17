class AdminController < ApplicationController

  before_filter :registered_user_as_admin


  ###
  #
  ###
  def index()
    
  end

  ###
  #
  ###
  def new_song()

    flash[:error] = nil
    flash[:notice] = nil

    if (params[:song])
      Song.create(params[:song])
      flash[:notice] = "Canci&oacute;n con nombre '#{params[:song][:name]}' creada."
    end

    redirect_to :controller => 'admin', :action => 'add_performers_and_authors_to_song'

  end


  ###
  #
  ###
  def new_band()

    flash[:error] = nil
    flash[:notice] = nil

    if (params[:band])
      Band.create(params[:band])
      flash[:notice] = "Banda con nombre '#{params[:band][:name]}' creada."
    end

    redirect_to :controller => 'admin', :action => 'add_performers_and_authors_to_song'

  end


  ###
  #
  ###
  def add_performers_and_authors_to_song()

    flash[:error] = nil
    flash[:notice] = nil

    bands = Band.find :all, :order => 'name'
    @performers = bands
    @authors    = bands

    if (params)
      if (session[:songs])
        @songs = session[:songs]
        session[:songs] = nil
      end

      if (params[:song])
        song = Song.new(params[:song])
        song.save()
      end
    end

  end

  ###
  #
  ##

  def add_song_data()

    if (params && params[:song] && params[:song][:id])
      song = Song.find_by_id(params[:song][:id].to_i())
      if (song)
          for performer in params[:song][:performers]
            song.performers << Performer.new(:song_id => params[:song][:id], :band_id => performer)
          end

          for author in params[:song][:authors]
            song.authors << Author.new(:song_id => params[:song][:id], :band_id => author)
          end
       end
       song.save()
    end

    flash[:notice] = "A&ntilde;adidos cantantes y/o autores a la canci&oacute;n."

    redirect_to :controller => 'admin', :action => 'add_performers_and_authors_to_song'

  end


  ###
  #
  ###
  def search_song()

    if (params[:song][:name])
      @songs = search_songs(params[:song][:name])
    elsif (params[:song][:id])
      @songs = [Song.find_by_id(params[:song][:id])]
    end

    session[:songs] = @songs

    if (params[:date])
      session[:reference_date] = Date.new(params[:date][:year].to_i(), params[:date][:month].to_i(), params[:date][:day].to_i())
    end

    if (params[:referer] == 'list_handling')
      redirect_to :controller => 'admin', :action => 'list_handling' 
    elsif (params[:referer] == 'add_performers_and_authors_to_song')
      redirect_to :controller => 'admin', :action => 'add_performers_and_authors_to_song'
    end
    
    
  end

  ###
  #
  ###
  def list_unconfirmed_songs()

    if (params[:date])
      @reference_date = Date.new(params[:date][:year].to_i(), params[:date][:month].to_i(), params[:date][:day].to_i())
    else
      @reference_date = Date.today()
    end

    @unconfirmed_songlist = search_unconfirmed_songs_in_date(@reference_date)

    session[:unconfirmed_songlist]  = @unconfirmed_songlist
    session[:reference_date]        = @reference_date

    redirect_to :controller => 'admin', :action => 'list_handling'

  end

  ###
  #
  ###
  def list_handling()

    RAILS_DEFAULT_LOGGER.debug "reference_date #{session[:reference_date]}"
    RAILS_DEFAULT_LOGGER.debug "params[:date] #{params[:date]}"

    if (session[:reference_date])
        @reference_date = session[:reference_date]
        session[:reference_date] = nil
    else
      if (params[:date])
        @reference_date = Date.new(params[:date][:year].to_i(), params[:date][:month].to_i(), params[:date][:day].to_i())
      else
        @reference_date = Date.today()
      end
    end

    @unconfirmed_songlist = search_unconfirmed_songs_in_date(@reference_date)

    if (session)
      if (session[:unconfirmed_songlist])
        @unconfirmed_songlist = session[:unconfirmed_songlist]
        session[:unconfirmed_songlist] = nil
      end

      if (session[:songs])
        @songs = session[:songs]
        session[:songs] = nil
      end
    end

    if (params[:song])
      if (params[:date])
        session_datetime = DateTime.new(params[:date][:year].to_i(), params[:date][:month].to_i(), params[:date][:day].to_i(),
                                        params[:time][:hour].to_i(), params[:time][:minutes].to_i())
        date = Date.new(session_datetime.year, session_datetime.month, session_datetime.day)
      else
        flash[:error] = 'Error a&ntilde;adiendo la canci&oacute;n a la lista.'
        return
      end

      list = List.find(:first, :conditions => ['day = ?', date])
      if (!list)
        list = List.create(:day => Date.new(session_datetime.year, session_datetime.month, session_datetime.day))
      end

      list_song = ListSong.create(:list_id => list.id, :song_id => params[:song][:id], :session_datetime => session_datetime)
      if (list_song)
        flash[:message] = 'Canci&oacute;n a&ntilde;adida a la sesi&oacute;n.'
      else
        flash[:error] = 'Error a&ntilde;adiendo la canci&oacute;n a la lista.'
      end

    end
    
  end

  ###
  #
  ###
  def create_list()
    @list = List.create(params[:list])
  end

  ###
  #
  ###
  def add_song_to_list()
    @list = List.find_by_id(params[:list_id])
    if (@list)
      @list.list_songs << ListSong.new(params[:list_song])
      @list.save()
      flash[:notice] = 'Canci&oacute;n a&ntilde;adiendo a la sesi&oacute;n.'
    else
      flash[:error] = 'Error a&ntilde;adiendo canci&oacute;n a la sesi&oacute;n.'
    end
  end

  ###
  #
  ###
  def mark_songs_as_revised()

    if (params[:song_ids])
      params[:song_ids].each do |id|
        song = SessionSong.find_by_id(id)
        if (song)
          song.revised = true
          song.save
        end
      end
    end

    session[:reference_date] = Date.new(params[:date][:year].to_i(), params[:date][:month].to_i(), params[:date][:day].to_i())

    redirect_to :back

  end

  private

    ###
    #
    ###
    def registered_user_as_admin()
      if (!session[:user_id] || session[:user_id] != 1)
        reset_session()
        redirect_to :controller => 'session', :action => 'login'
      end
    end

    ###
    #
    ###
    def search_songs(text_to_find)

      if (text_to_find && text_to_find.length() != 0)
        songs = Song.find(:all, :conditions => ["UPPER(name) like ?", "%#{params[:song][:name].upcase()}%"], :order => 'name')
      end

      return songs
      
    end

    ###
    #
    ###
    def search_unconfirmed_songs_in_date(reference_date)
      session_init_datetime = DateTime.new(reference_date.year, reference_date.month, reference_date.day, 0, 0, 0)
      session_end_datetime  = DateTime.new(reference_date.year, reference_date.month, reference_date.day, 23, 59, 59)

      return SessionSong.find(:all, :conditions => ['session_datetime between ? AND ? AND revised = ?', session_init_datetime, session_end_datetime, false], :order => 'session_datetime')
    end

end

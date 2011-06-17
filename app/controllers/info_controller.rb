class InfoController < ApplicationController

  ###
  #
  ###
  def index()

    # Page title
    @title = 'Rock & Gol, la mejor emisora del mundo !!!'

    # HTML meta tags information.
    @meta_description_tag = "Esta es una web para uso y disfrute de todas aquellas personas que escuchan ese gran programa de radio llamado Rock & Gol."

    @registered_users_number = User.count_by_sql("SELECT count(*) FROM users")

  end
  
  ###
  #
  ###
  def frequencies()

    # Page title
    @title = 'Frecuencias donde encontrar Rock & Gol !!!'

    @provinces = Province.find(:all, :order=> 'name')

  end

  ###
  #
  ###
  def webs_and_blogs()

    # Page title
    @title = 'Enlaces de gente relacionada con Rock & Gol !!!'

    @people = Person.find(:all, :order => 'id')
    #for person in @people
    #  RAILS_DEFAULT_LOGGER.debug person.firstname + ' ' + person.lastname
    #end
  end

  ###
  #
  ###
  def ideas()
    @ideas = Idea.find(:all, :conditions => "done = false", :order => 'score DESC')
  end
  
  ###
  #
  ###
  def save_idea()
    if (session[:user_id] == 1)
      @idea = Idea.create(params[:idea])
      flash[:notice] = "Idea a&ntilde;adida correctamente."
    else
      flash[:error] = 'No eres usuario administrador.'
    end

    redirect_to :controller => 'info', :action => 'ideas'

  end

  ###
  #
  ###
  def vote_idea()
    if (params[:id])
      idea = Idea.find(params[:id])
      if (idea)
        idea.voted()
        idea.save
      end
    end

    redirect_to :controller => 'info', :action => 'ideas'

  end

end

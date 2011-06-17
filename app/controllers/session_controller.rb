class SessionController < ApplicationController


    ###
    #
    ###
    def register()

        @title = 'Registration'

        flash[:error] = nil
        flash[:notice] = nil

        if (!params[:commit] && !params[:user])
            return
        end

        @user = User.new(params[:user])
        if (@user.save())
            @user = nil
            flash[:notice] = 'User created.'
        else
          flash[:error] = 'Error creating user.'
        end

    end

    ###
    #
    ###
    def login()

      @title = 'Entrada en zona de usuarios registrados.'

        if (!params[:commit] && !params[:user])
          flash[:error] = nil
          flash[:notice] = nil
          return
        end

        if (!params[:user][:login] || !params[:user][:password])
          flash[:error] = 'Usuario y password DEBEN ser informados'
          return
        end

        user = User.find(:first, :conditions => ["login = ? AND password = ?", params[:user][:login], params[:user][:password]])
        if (user)
            session[:user_id] = user.id
            user_active_connections = finish_and_remove_other_day_connections(user_active_connections(user.id))
            if (user_active_connections.length == 0)
              Login.create(:user_id => user.id, :login_datetime => DateTime.now())
            end
            redirect_to :controller => 'info', :action => 'index'
        else
            flash[:error] = 'Usuario o password err&oacute;neo.'
        end
    end

    ###
    #
    ###
    def logout()
        login = user_active_connections(session[:user_id])
        if (login)
          login.each do |item|
            item.logout_datetime = DateTime.now()
            item.save()
          end
        end

        # Reset the session in order to begin a new cycle.
        reset_session()

        #Redirect to home page.
        redirect_to :controller => 'info', :action => 'index'
    end

    private

    ###
    #
    ###
    def finish_and_remove_other_day_connections(connections)
      connections.each do |login|
        if (!login.login_datetime.to_date().today?)
          login.logout_datetime = DateTime.now()
          login.save()
          connections.delete(login)
        end
      end
    end

    ###
    #
    ###
    def user_active_connections(user_id)
      return Login.find_all_by_user_id_and_logout_datetime(user_id, nil)
    end

    ###
    #
    ###
    def already_logged_in_user?(user_id)
      return Login.find(:all, :conditions => ['user_id = ? and logout_datetime is null', user_id]).length != 0
    end

    ###
    #
    ###
    def reset_session()
      session.keys.each do |key|
        session[key] = nil unless (key == 'session_id')
      end
    end

end

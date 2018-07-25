module UsersHelper
	#Types of action that a person might wanna do
	ACTION_ARTICLE=0#Needs RED badge
	ACTION_DISCUSSION=1#Needs Yellow
	ACTION_DISCUSSION_COMMENT=2#Needs Yellow
	# including commenting in post,article,liking creating albums etc. 
	ACTION_OTHER=3#Needs Blue

	ACCESS_ACCOUNT_BLOCKED=0
	ACCESS_BADGE_NOTEARNED=1
	ACCESS_NO_LOGIN=2


    #Logs a adminuser in, we only set cookie. currentuser var is set only when its function  is called
	def log_in (user)
		#Session is a rails method which saves something called as userid in a cookie
		session[:user_name]=user.username

	end

	def find_user(param)
	  	#find the user by username. here session is the hash inside params coz that is what we specified in the form_for of login
		user=User.find_by(param)

		return user
	end

	#gets the currently logged in user
    def current_user
		#if there is a session object, use it. otherwise look at the cookie
		if (user_name = session[:user_name])#This is not comparing with user_name. it is assigning to it
			#if currentuser has someone it returns him. if it is the first call it will be empty in which case
			#we check the cookie and get the id of the guy who is logged in
			#@current_user ||= AdminUser.find_by(username: user_name)
			@current_user ||= find_user(username: user_name)

		#if there was no session id it means either nothing is saved or browser was closed. check for cookie
		elsif (user_name = cookies.signed[:user_name])	#The signed function will decrypt the id and give
			#find the user in db whose id is stored in cookie
			#user = AdminUser.find_by(username: user_name)	
			user = find_user(username: user_name)	

			 #The authenticated? method is defined in AdminUser model and authenticates this against what is saved in db using remember token
			 #So that way it comes to know if the id belongs to the same guy who was logged in prevoiusly
			if user && user.authenticated?(cookies[:remember_token])
				#log in the user
				log_in user
				#update the variable so that next time it doesnt have to execute this elseif statement
				@current_user = user
			end
		end
	end
    
	
	#calls the current_user method and tells if anyone is logged in at all
	def logged_in?
		#if currentuser.nil returns true then logedin is false
		!current_user.nil?
	end

	#Logs a admin user out
	def log_out
		#delete the cookie
		forget(current_user)
		#delete the sessionid
  		session[:user_name]=nil
  		#then currentuser is deleted
		current_user=nil
	end

	# Remembers a user in a persistent session.
	def remember(user)
		#calls the remember method in AdminUser model
		user.remember
		#cookies method helps to do permanent sessions. This is actually a syntactic sugar for a bigger thing. 
		cookies.permanent.signed[:user_name] = user.username
		#save the remembertoken as well. this dosent need to be encrypted
		cookies.permanent[:remember_token] = user.remember_token
	end

	# Forgets a persistent session.
	def forget(user)
		#call the model.forget api to delete the remember_token from user
		user.forget
		#remove cookie from browser
		cookies[:user_name]=nil
		#remove remembertoken from browser
		cookies[:remember_token]=nil
	end




	def result_to_map result
		amap=[]
	  	result.each do |item|
			amap[item.id]=item
	  	end
	  	return amap
	end

	def numberize number
		return number
	end
	#function which decieds what I can do. ie if i hav access to post artcles, comment discussion etc
	#it checkes action against user badge and other credentials
	def access action
		if current_user
        	return true
        else
        	return false
        end

	end
end

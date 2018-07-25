require 'securerandom'
class UsersController < ApplicationController
  include UsersHelper

PAGINATION_PERPAGE=10
  skip_before_filter :verify_authenticity_token, only: :create
		def new
		    	#binding.pry

			if current_user
				redirect_to current_user  
			else
         		render "users/new"
			end

		end



	  def show

	  	#if a request comes in to show a users profile page it comes here. From the id get the user
	  	@user=User.find_by(id: params[:id])
	  	#Show the page only if this user is the currently logged in user
	  	if @user.nil? || @user!=current_user then
	  		#if the user dosent exist or if he is not currently logged in we redirect him  to homepage
	  		#redirect_to home_path
	        #@user=User.new
	        if current_user
				#binding.pry

				redirect_to current_user  
	        else
         		render "users/new"
         		
			end
		else
				contract=get_sunlogin_contract

			@access=contract.call.access_rights(current_user.address)

     		render "users/show"
	  	end
	    #respond_to do |format|
	        #format.html do 
	            #render "users/show"
	        #end
	    #end
	  end


	def signinform
		#write into bchain
		#binding.pry
		@uuid=SecureRandom.uuid
		contract=get_sunlogin_contract

		contract.transact_and_wait.login_promise(@uuid.to_s)
        respond_to do |format|
            format.js {render :file => "users/show_signinform.js.erb" }
        end
        
    end

    def login
		uuid=params[:uuid]
		contract=get_sunlogin_contract
		islogedin=contract.call.is_login(uuid)
#binding.pry
		if islogedin
			address=contract.call.get_address(uuid)
			address="0x"+address
			contract_reg = get_reg_contract
			user_data=contract_reg.call.users(address)
		    begin
  				@user=User.create_from_block_auth(address,user_data)
		  		
		    rescue
				flash[:error] = "Can't authorize you..."
		    else
		  		#if the signup is succeeded then we redirect him to homepage
		  		#Commenting below login code becoz we dont want to login user just after signup. We will send a mail and user will have to activate his acciunt
		  		
		  		log_in @user
		      	remember @user 

		      	session[:user_id] = @user.id
		      	flash[:success] = "Welcome, #{@user.name}!"
		        
		        #Todo: do not log him in yet. make him activate his account first
		  		redirect_to @user
		  	end

		end

    end

    def buy
    	id=params[:id].to_i
    	if id==0 or id==1
			contract=get_sunlogin_contract

			contract.transact_and_wait.grant_access(current_user.address, id)
			@d=34;

		end
  		redirect_to current_user

    end




  #called when admins and recruiters logout
  def destroy
  	#call logout method in admin_helper but only if we r loggedin
  	log_out if logged_in?
  	#redirect him to homepage
  	redirect_to root_path
  end


  private 	
  	def get_reg_contract
		client = Ethereum::HttpClient.new('http://localhost:7545')
		data_hash_reg = JSON.parse(File.read('public/Registration.json'))
		contract_reg = Ethereum::Contract.create(client: client,name: "Registration", address: "0x83ba997c0f084af8967e3908a988140649685fe0", abi: data_hash_reg["abi"])
  		return contract_reg
  	end
  	def get_sunlogin_contract
		client = Ethereum::HttpClient.new('http://localhost:7545')
		data_hash = JSON.parse(File.read('public/Sun_Login.json'))
		contract = Ethereum::Contract.create(client: client,name: "Sun_Login", address: "0x6fc6814d261873d26f845686b47ad438c0fbb0cf", abi: data_hash["abi"])
  		return contract
  	end
end

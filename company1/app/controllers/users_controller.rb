class UsersController < ApplicationController

	def show
	end

	def signinform
		#write into bchain

        respond_to do |format|
            format.js {render :file => "users/show_signinform.js.erb" }
        end
        
    end
end

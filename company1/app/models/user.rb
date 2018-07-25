require 'digest/sha1'

class User < ApplicationRecord
	has_secure_password


	#This accessor will have a unique string and the database will have a digest version of this string for 
	#the user who is logged in currently
	attr_accessor :remember_token

    def get_profile_pic
		return profilepic
	end
    def get_profile_pic_url
		return profilepic
        
	end

	# Returns the hash digest of the given string.
	def digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# Returns a random string token.
	def new_token
		SecureRandom.urlsafe_base64
	end

	#Saves the remember token in db
	def remember
		#This creates and assignes a new string token into the accessor
		self.remember_token = new_token
		#We can call update_attribute directly becoz we are alredy in the Model object
		#update_attribute can change db itemw for users without passing in a password
		update_attribute(:remember_digest, digest(remember_token))
	end

	def get_remembertoken
		return self.remember_token
	end

	# Returns true if the given token matches the digest.
	def authenticated?(remember_token)
		#if logged in from multiple browsers, and logged out from 1, this cud be null
		return false if remember_digest.nil?
		#hashes the token and compares it with digest
		BCrypt::Password.new(remember_digest).is_password?(remember_token)# you can use == also in place of is_password
	end

	# Forgets a user.
	def forget
		update_attribute(:remember_digest, nil)
	end

	#def username
		#return username
	#end




	 private




  class << self
	    def create_from_block_auth(address, data)
			begin
				user = find_or_initialize_by(address: address)
				#user.username = data[0]
				user.username = address

				user.password=address
				user.name=data[1]
				user.profilepic = data[0]
				user.save!
				return user

			rescue Exception=> ex

			end

	    end
	  end
  
end

require 'securerandom'
class UsersController < ApplicationController

	def show
	end

	def signinform
		#write into bchain
		client = Ethereum::HttpClient.new('http://localhost:7545')
		data_hash = JSON.parse(File.read('public/MS_Login.json'))
		#binding.pry
		@uuid=SecureRandom.uuid

		contract = Ethereum::Contract.create(client: client,name: "MS_Login", address: "0xa41097a3753fa541b973b3f5a1204fbc20d7f11f", abi: data_hash["abi"])
		contract.transact_and_wait.login(@uuid.to_s)
        respond_to do |format|
            format.js {render :file => "users/show_signinform.js.erb" }
        end
        
    end

    def login
		uuid=params[:uuid]
		client = Ethereum::HttpClient.new('http://localhost:7545')
		data_hash = JSON.parse(File.read('public/MS_Login.json'))

		contract = Ethereum::Contract.create(client: client,name: "MS_Login", address: "0xa41097a3753fa541b973b3f5a1204fbc20d7f11f", abi: data_hash["abi"])
		islogedin=contract.call.is_login(uuid)

		if islogedin
			address=contract.call.get_address(uuid)
			address="0x"+address
			data_hash_reg = JSON.parse(File.read('public/Registration.json'))
			contract_reg = Ethereum::Contract.create(client: client,name: "Registration", address: "0x91fad34ec4077bccb612eb354e3275e9f2468348", abi: data_hash_reg["abi"])
			user_data=contract_reg.call.users(address)
		binding.pry
			user_data=contract_reg.call.users(address)

		end

       	respond_to do |format|
            format.js {render :file => "users/show_signinform.js.erb" }
        end
    end
end

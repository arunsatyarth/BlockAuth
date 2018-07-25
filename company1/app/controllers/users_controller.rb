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
		binding.pry

       	respond_to do |format|
            format.js {render :file => "users/show_signinform.js.erb" }
        end
    end
end

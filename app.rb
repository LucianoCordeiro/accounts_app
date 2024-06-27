require 'sinatra'
require 'sinatra/json'

require_relative 'controllers/account_controller.rb'
require_relative 'models/account.rb'
require_relative 'models/transaction.rb'
require_relative 'services/make_transaction.rb'

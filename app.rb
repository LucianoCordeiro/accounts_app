require 'sinatra/base'
require 'sinatra/json'
require 'json'

require_relative 'models/account.rb'
require_relative 'models/transaction.rb'
require_relative 'services/deposit.rb'
require_relative 'services/withdraw.rb'
require_relative 'services/transfer.rb'

class NotFoundError < StandardError; end;

class App < Sinatra::Base
  get '/balance' do
    account = Account.find(params[:account_id]) || raise(NotFoundError)

    status 200
    json(account.balance)
  rescue NotFoundError => _
    status 404
    json(0)
  end

  post '/event' do
    body_params = JSON.parse(request.body.read, {symbolize_names: true})

    operation = Object.const_get(body_params[:type].capitalize)

    transaction_response = operation.new(body_params).run

    status 201
    json(transaction_response)
  rescue NotFoundError => _
    status 404
    json(0)
  end

  post '/reset' do
    Account.reset

    status 200
    "OK"
  end
end

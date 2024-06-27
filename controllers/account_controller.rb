class NotFoundError < StandardError; end;

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

  transaction_response = MakeTransaction.new(body_params).run

  status 201
  json(transaction_response)
rescue NotFoundError => _
  status 404
  json(0)
end

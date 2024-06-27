class NotFoundError < StandardError; end;

post '/event' do
  body_params = JSON.parse(request.body.read, {symbolize_names: true})

  transaction_response = MakeTransaction.new(body_params).run

  status 201
  json(transaction_response)
rescue NotFoundError => _
  status 404
  json(0)
end

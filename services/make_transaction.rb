class MakeTransaction
  attr_reader :amount, :type, :destination, :origin, :id, :account

  def initialize(params = {})
    @type = params[:type]
    @destination = params[:destination]
    @origin = params[:origin]
    @amount = params[:amount]

    @id = type == "deposit" ? destination : origin
    @account = Account.find(id)
  end

  def run
    send(type)
  end

  def deposit
    create_account unless account
    create_transaction

    {
      destination: {
        id: id,
        balance: account.balance
      }
    }
  end

  def withdraw
    account ? create_transaction : raise(NotFoundError)

    {
      origin: {
        id: id,
        balance: account.balance
      }
    }
  end

  def transfer
    account ? create_transaction : raise(NotFoundError)

    {
      origin: {
        id: id,
        balance: account.balance
      },
      destination: {
        id: destination,
        balance: amount
      }
    }
  end

  def create_transaction
    account.transactions << Transaction.new(type: type, amount: amount)
  end

  def create_account
    @account = Account.new(id)
  end
end

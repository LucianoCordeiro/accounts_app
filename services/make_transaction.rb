class MakeTransaction
  attr_reader :amount, :type, :destination, :origin, :origin_account, :destination_account

  def initialize(params = {})
    @type = params[:type]
    @destination = params[:destination]
    @origin = params[:origin]
    @amount = params[:amount]

    @origin_account = Account.find(origin)
    @destination_account = Account.find(destination)
  end

  def run
    send(type)
  end

  private

  def deposit
    create_account unless destination_account
    create_deposit_transaction

    {
      destination: {
        id: destination_account.id,
        balance: destination_account.balance
      }
    }
  end

  def withdraw
    origin_account ? create_withdraw_transaction : raise(NotFoundError)

    {
      origin: {
        id: origin_account.id,
        balance: origin_account.balance
      }
    }
  end

  def transfer
    raise(NotFoundError) unless origin_account

    create_withdraw_transaction
    create_deposit_transaction if destination_account

    {
      origin: {
        id: origin_account.id,
        balance: origin_account.balance
      },
      destination: {
        id: destination_account&.id || destination,
        balance: destination_account&.balance || amount
      }
    }
  end

  def create_deposit_transaction
    destination_account.transactions << Transaction.new(type: "deposit", amount: amount)
  end

  def create_withdraw_transaction
    origin_account.transactions << Transaction.new(type: "withdraw", amount: amount)
  end

  def create_account
    @destination_account = Account.new(destination)
  end
end

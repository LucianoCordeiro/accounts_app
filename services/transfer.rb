class Transfer
  attr_reader :amount, :destination, :destination_account, :origin_account

  def initialize(params = {})
    @amount = params[:amount]
    @destination = params[:destination]

    @destination_account = Account.find(params[:destination])
    @origin_account = Account.find(params[:origin]) || raise(NotFoundError)
  end

  def run
    origin_account.withdraw(amount)
    destination_account.deposit(amount) if destination_account

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
end

class Deposit
  attr_reader :amount, :destination_account

  def initialize(params = {})
    @amount = params[:amount]

    @destination_account = Account.find(params[:destination]) || Account.new(params[:destination])
  end

  def run
    destination_account.deposit(amount)

    {
      destination: {
        id: destination_account.id,
        balance: destination_account.balance
      }
    }
  end
end

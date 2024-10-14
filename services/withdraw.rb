class Withdraw
  attr_reader :amount, :origin_account

  def initialize(params = {})
    @amount = params[:amount]

    @origin_account = Account.find(params[:origin]) || raise(NotFoundError)
  end

  def run
    origin_account.withdraw(amount)

    {
      origin: {
        id: origin_account.id,
        balance: origin_account.balance
      }
    }
  end
end

class Account
  attr_reader :id, :transactions

  @@accounts = []

  def initialize(id)
    @id = id
    @transactions = []
    @@accounts << self
  end

  def self.find(id)
    @@accounts.find { |a| a.id == id }
  end

  def balance
    @transactions.sum { |t| t.type == "deposit" ? t.amount : -t.amount }.round(2)
  end
end

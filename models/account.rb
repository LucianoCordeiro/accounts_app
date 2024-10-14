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

  def self.reset
    @@accounts = []
  end

  def balance
    @transactions.sum { |t| t.type == "deposit" ? t.amount : -t.amount }.round(2)
  end

  def deposit(amount)
    @transactions << Transaction.new(type: "deposit", amount: amount)
  end

  def withdraw(amount)
    @transactions << Transaction.new(type: "withdraw", amount: amount)
  end
end

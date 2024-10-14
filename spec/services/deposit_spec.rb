require "spec_helper"

RSpec.describe Deposit do

  after { Account.reset }

  it "new account" do
    deposit = Deposit.new(
      {
        type: "deposit",
        destination: "100",
        amount: 10
      }
    )

    expect(deposit.run).to eql(
      {
        destination: {
          id: "100",
          balance: 10
        }
      }
    )
  end

  it "existing account" do
    account = Account.new("100")
    account.deposit(120)

    deposit = Deposit.new(
      {
        type: "deposit",
        destination: "100",
        amount: 10
      }
    )

    expect(deposit.run).to eql(
      {
        destination: {
          id: "100",
          balance: 130
        }
      }
    )
  end
end

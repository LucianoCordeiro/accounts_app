require "spec_helper"

RSpec.describe Withdraw do

  after { Account.reset }

  it "success" do
    account = Account.new("100")
    account.deposit(120)

    withdraw = Withdraw.new(
      {
        type: "withdraw",
        origin: "100",
        amount: 10
      }
    )

    expect(withdraw.run).to eql(
      {
        origin: {
          id: "100",
          balance: 110
        }
      }
    )
  end

  it "origin not found" do
    expect {
      Withdraw.new(
        {
          type: "withdraw",
          origin: "100",
          amount: 10
        }
      )
    }.to raise_error NotFoundError
  end
end

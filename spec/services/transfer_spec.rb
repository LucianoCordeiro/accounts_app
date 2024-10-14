require "spec_helper"

RSpec.describe Transfer do

  after { Account.reset }

  it "with destination" do
    origin_account = Account.new("100")
    destination_account = Account.new("500")

    origin_account.deposit(120)

    transfer = Transfer.new(
      {
        type: "transfer",
        origin: "100",
        destination: "500",
        amount: 10
      }
    )

    expect(transfer.run).to eql(
      {
        origin: {
          id: "100",
          balance: 110
        },
        destination: {
          id: "500",
          balance: 10
        }
      }
    )
  end

  it "destination not found" do
    origin_account = Account.new("100")

    origin_account.deposit(120)

    transfer = Transfer.new(
      {
        type: "transfer",
        origin: "100",
        destination: "500",
        amount: 10
      }
    )

    expect(transfer.run).to eql(
      {
        origin: {
          id: "100",
          balance: 110
        },
        destination: {
          id: "500",
          balance: 10
        }
      }
    )
  end

  it "origin not found" do
    destination_account = Account.new("500")

    expect {
      Transfer.new(
        {
          type: "transfer",
          origin: "100",
          destination: "500",
          amount: 10
        }
      )
    }.to raise_error NotFoundError
  end
end

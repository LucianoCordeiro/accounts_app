require "spec_helper"

RSpec.describe MakeTransaction do

  after { Account.reset }

  describe "deposit" do
    it "new account" do
      make_transaction = MakeTransaction.new(
        {
          type: "deposit",
          destination: "100",
          amount: 10
        }
      )

      expect(make_transaction.run).to eql(
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
      account.transactions << Transaction.new(type: "deposit", amount: 120)

      make_transaction = MakeTransaction.new(
        {
          type: "deposit",
          destination: "100",
          amount: 10
        }
      )

      expect(make_transaction.run).to eql(
        {
          destination: {
            id: "100",
            balance: 130
          }
        }
      )
    end
  end

  describe "withdraw" do
    it "success" do
      account = Account.new("100")
      account.transactions << Transaction.new(type: "deposit", amount: 120)

      make_transaction = MakeTransaction.new(
        {
          type: "withdraw",
          origin: "100",
          amount: 10
        }
      )

      expect(make_transaction.run).to eql(
        {
          origin: {
            id: "100",
            balance: 110
          }
        }
      )
    end

    it "not found" do
      make_transaction = MakeTransaction.new(
        {
          type: "withdraw",
          origin: "100",
          amount: 10
        }
      )

      expect { make_transaction.run }.to raise_error NotFoundError
    end
  end

  describe "transfer" do
    it "with destination" do
      origin_account = Account.new("100")
      destination_account = Account.new("500")

      origin_account.transactions << Transaction.new(type: "deposit", amount: 120)

      make_transaction = MakeTransaction.new(
        {
          type: "transfer",
          origin: "100",
          destination: "500",
          amount: 10
        }
      )

      expect(make_transaction.run).to eql(
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

      origin_account.transactions << Transaction.new(type: "deposit", amount: 120)

      make_transaction = MakeTransaction.new(
        {
          type: "transfer",
          origin: "100",
          destination: "500",
          amount: 10
        }
      )

      expect(make_transaction.run).to eql(
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

      make_transaction = MakeTransaction.new(
        {
          type: "transfer",
          origin: "100",
          destination: "500",
          amount: 10
        }
      )

      expect { make_transaction.run }.to raise_error NotFoundError
    end
  end
end

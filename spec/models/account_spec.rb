require "spec_helper"

RSpec.describe Account do

  after { Account.reset }

  it "find" do
    expect(Account.find("3")).to be_blank

    Account.new("3")

    expect(Account.find("3")).to be_present
  end

  it "reset" do
    Account.new("3")

    expect(Account.find("3")).to be_present

    Account.reset

    expect(Account.find("3")).to be_blank
  end

  it "balance" do
    account = Account.new("3")
    account.deposit(16.98)
    account.withdraw(4.81)

    expect(account.balance).to eql(12.17)
  end
end

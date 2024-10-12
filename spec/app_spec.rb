require "spec_helper"

RSpec.describe App do

  def app
    App
  end

  after { Account.reset }

  describe "balance" do
    subject { get "/balance?account_id=3" }

    it "zero balance" do
      Account.new("3")

      subject

      expect(last_response.body).to eql("0")
      expect(last_response.status).to eql 200
    end

    it "positive balance" do
      account = Account.new("3")
      account.transactions << Transaction.new(type: "deposit", amount: 15.22)

      subject

      expect(last_response.body).to eql("15.22")
      expect(last_response.status).to eql 200
    end

    it "not found" do
      subject

      expect(last_response.body).to eql("0")
      expect(last_response.status).to eql 404
    end
  end

  describe "event" do
    let(:request_body) {
      {
        type: "deposit",
        destination: "100",
        amount: 10
      }
    }

    let (:response_body) {
      {
        destination: {
          id: "100",
          balance: 10
        }
      }
    }

    let(:action) { double("transaction") }

    before { allow(MakeTransaction).to receive(:new).with(request_body).and_return(action) }

    subject { post("/event", request_body.to_json, "CONTENT_TYPE" => "application/json") }

    it "successful" do
      allow(action).to receive(:run).and_return(response_body)

      subject

      expect(last_response.body).to eql(response_body.to_json)
      expect(last_response.status).to eql 201
    end

    it "failed" do
      allow(action).to receive(:run).and_raise(NotFoundError)

      subject

      expect(last_response.body).to eql("0")
      expect(last_response.status).to eql 404
    end
  end

  it "reset" do
    Account.new("3")

    expect(Account.find("3")).to be_present

    post "/reset"

    expect(last_response.body).to eql("OK")
    expect(last_response.status).to eql 200

    expect(Account.find("3")).to be_blank
  end
end

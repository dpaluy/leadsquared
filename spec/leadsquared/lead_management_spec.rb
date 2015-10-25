require 'spec_helper'

describe Leadsquared::LeadManagement do
  let(:mock_connection)   { double("connection") }
  let(:valid_response)    { double("response", status: 200, body: {id: '1234'}.to_json) }
  let(:invalid_response)  { double("response", status: 400, body: "") }

  before do
    expect( Leadsquared::Client).to receive(:new).and_return mock_connection
  end

  describe "#create_lead" do
    let(:url) { '/v2/LeadManagement.svc/Lead.Create' }
    subject { Leadsquared::LeadManagement.new }
    let(:email) { "test@example.com" }
    let(:first_name) { "Bob" }
    let(:last_name) { "Zeiger" }
    let(:body) do
      [
        {
          "Attribute": "EmailAddress",
          "Value": email
        },
        {
          "Attribute": "FirstName",
          "Value": first_name
        },
        {
          "Attribute": "LastName",
          "Value": last_name
        }
      ]
    end

    it "valid request with given params" do
      expect(mock_connection).to receive(:post).with(url, {}, body.to_json).and_return valid_response
      response = subject.create_lead(email, first_name, last_name)
    end

    it "invalid request" do
      expect(mock_connection).to receive(:post).with(url, {}, body.to_json).and_return invalid_response
      expect {
        subject.create_lead(email, first_name, last_name)
      }.to raise_error(Leadsquared::InvalidRequestError)
    end
  end
end

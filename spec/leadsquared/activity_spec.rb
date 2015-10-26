require 'spec_helper'

describe Leadsquared::Lead do
  let(:mock_connection)   { double("connection") }
  let(:service) { '/v2/ProspectActivity.svc/' }
  let(:lead_id) { "3131ea6a-bb20-4457-b183-ddf6d8716dfe" }
  let(:email) { "test@example.com" }
  subject { Leadsquared::Activity.new }

  before do
    expect(Leadsquared::Client).to receive(:new).and_return mock_connection
  end

  describe "#get_activities" do
    let(:url) { "#{service}Retrieve" }
    let(:activity_event_id) { 201 }
    let(:body) do
      {
        "Parameter" => {"ActivityEvent" => activity_event_id},
        "Paging" => {"Offset" => 0, "RowCount" => 10}
      }
    end
    let(:success_response) do
      {
        "RecordCount" => 0,
        "ProspectActivities" => []
      }
    end
    let(:valid_response) { double("response", status: 200, body: success_response.to_json) }

    it "valid request with existing id" do
      expect(mock_connection).to receive(:post).with(url, {leadId: lead_id}, body.to_json).and_return valid_response
      subject.get_activities(lead_id, activity_event_id)
    end

  end
end

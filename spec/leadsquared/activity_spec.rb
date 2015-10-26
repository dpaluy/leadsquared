require 'spec_helper'

describe Leadsquared::Lead do
  let(:mock_connection)   { double("connection") }
  let(:service) { '/v2/ProspectActivity.svc/' }
  let(:lead_id) { "3131ea6a-bb20-4457-b183-ddf6d8716dfe" }
  let(:email) { "test@example.com" }
  let(:current_utc_time) { Time.now.utc.to_s.gsub(/ UTC$/, "") }
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

  describe "#create_activity_type" do
    let(:url) { "#{service}CreateType" }
    let(:score) { 10 }
    let(:activity_name) { "New Activity" }
    let(:description) { "Some Description" }
    let(:body) do
      {
        "ActivityEventName" => activity_name,
        "Score" => score,
        "Description" => description,
        "Direction" => 0
      }
    end
    let(:success_response) do
      {
        "Status": "Success",
        "Message": {
          "Id": "206"
        }
      }
    end
    let(:valid_response) { double("response", status: 200, body: success_response.to_json) }

    it "activity event" do
      expect(mock_connection).to receive(:post).with(url, {}, body.to_json).and_return valid_response
      response = subject.create_activity_type(activity_name, score, description)
      expect(response).to eq("206")
    end
  end

  describe "#create" do
    let(:url) { "#{service}Create" }
    let(:id) { "d91bd87a-7bca-11e5-a199-22000aa4133b" }
    let(:event_id) { "201" }
    let(:body) do
      {
        "EmailAddress"      => email,
        "ActivityEvent"     => event_id,
        "ActivityNote"      => nil,
        "ActivityDateTime"  => current_utc_time,
        "FirstName"         => nil,
        "LastName"          => nil
      }
    end

    let(:success_response) do
      {
        "Status": "Success",
        "Message": {
          "Id": id
        }
      }
    end
    let(:valid_response) { double("response", status: 200, body: success_response.to_json) }

    before do
      Timecop.freeze(Time.local(2015))
    end

    after do
      Timecop.return
    end

    it "valid activity" do
      expect(mock_connection).to receive(:post).with(url, {}, body.to_json).and_return valid_response
      response = subject.create(email, event_id)
      expect(response).to eq(id)
    end
  end

  describe "#create_lead_activity" do
    let(:url) { "#{service}Create" }
    let(:id) { "d91bd87a-7bca-11e5-a199-22000aa4133b" }
    let(:event_id) { "201" }
    let(:notes) { "Some Description" }
    let(:body) do
      {
        "RelatedProspectId" => lead_id,
        "ActivityEvent"     => event_id,
        "ActivityNote"      => notes,
        "ActivityDateTime"  => current_utc_time
      }
    end

    let(:success_response) do
      {
        "Status": "Success",
        "Message": {
          "Id": id
        }
      }
    end
    let(:valid_response) { double("response", status: 200, body: success_response.to_json) }

    before do
      Timecop.freeze(Time.local(2015))
    end

    after do
      Timecop.return
    end

    it "valid activity" do
      expect(mock_connection).to receive(:post).with(url, {leadId: lead_id}, body.to_json).and_return valid_response
      response = subject.create_lead_activity(lead_id, event_id, notes)
      expect(response).to eq(id)
    end
  end

end

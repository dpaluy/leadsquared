require 'spec_helper'

describe Leadsquared::Lead do
  let(:mock_connection)   { double("connection") }
  let(:lead_id) { "3131ea6a-bb20-4457-b183-ddf6d8716dfe" }
  let(:email) { "test@example.com" }
  let(:first_name) { "Bob" }
  let(:last_name) { "Zeiger" }
  let(:attributes) do
    {"FirstName" => first_name, "LastName" => last_name}
  end

  let(:invalid_response_body) do
    {
      "Status" => "Error",
      "ExceptionType" => "MXDuplicateEntryException",
      "ExceptionMessage" => "Duplicate entry 'john.smith@acmeconsulting.co' for key 'UQ_Prospect_Base_EmailAddress'"
    }
  end
  let(:invalid_response)  { double("response", status: 500, body: invalid_response_body) }
  let(:service) { '/v2/LeadManagement.svc/' }

  subject { Leadsquared::Lead.new }

  before do
    expect( Leadsquared::Client).to receive(:new).and_return mock_connection
  end

  describe "#get_lead_by_id" do
    let(:url) { "#{service}Leads.GetById" }
    let(:valid_response) { double("response", status: 200, body: success_response.to_json) }
    let(:empty_response) { double("response", status: 200, body: [].to_json) }
    let(:success_response) do
      [
        {
          "ProspectID" => " Lead Id ",
          "FirstName" => "Syed",
          "LastName" => "Rizwan Ali",
          "EmailAddress" => "rizwan@yopmail.com",
          "Company" => "Roga",
          "SourceReferrer" => ""
        }
      ]
    end

    it "valid request with existing id" do
      expect(mock_connection).to receive(:get).with(url, {id: lead_id}).and_return valid_response
      response = subject.get_lead_by_id(lead_id)
    end

    it "with missing id" do
      missing_id = "12345"
      expect(mock_connection).to receive(:get).with(url, {id: missing_id}).and_return empty_response
      response = subject.get_lead_by_id(missing_id)
    end
  end

  describe "#get_lead_by_email" do
    let(:url) { "#{service}Leads.GetByEmailaddress" }
    let(:email) { "test@example.com" }
    let(:valid_response) { double("response", status: 200, body: success_response.to_json) }
    let(:empty_response) { double("response", status: 200, body: [].to_json) }
    let(:success_response) do
      [
        {
          "ProspectID" => " Lead Email ",
          "FirstName" => "Syed",
          "LastName" => "Rizwan Ali",
          "EmailAddress" => "rizwan@yopmail.com",
          "Company" => "Roga",
          "SourceReferrer" => ""
        }
      ]
    end

    it "valid request with existing id" do
      expect(mock_connection).to receive(:get).with(url, {emailaddress: email}).and_return valid_response
      response = subject.get_lead_by_email(email)
    end

    it "with missing id" do
      expect(mock_connection).to receive(:get).with(url, {emailaddress: email}).and_return empty_response
      response = subject.get_lead_by_email(email)
    end
  end

  describe "#quick_search" do
    let(:url) { "#{service}Leads.GetByQuickSearch" }
    let(:key) { "Jhon" }
    let(:valid_response) { double("response", status: 200, body: success_response.to_json) }
    let(:empty_response) { double("response", status: 200, body: [].to_json) }
    let(:success_response) do
      [
        {
          "ProspectID": "16837df6-ec85werwer9b1f3a902",
          "FirstName" => "Syed",
          "LastName" => "Rizwan Ali",
          "EmailAddress" => "rizwan@yopmail.com",
          "Company" => "Roga",
          "SourceReferrer" => ""
        },
        {
          "ProspectID": "16837df6-ec85werwer9b1f3a903",
          "FirstName" => "Syed2",
          "LastName" => "Rizwan Ali",
          "EmailAddress" => "rizwan2@yopmail.com",
          "Company" => "Roga",
          "SourceReferrer" => ""
        }
      ]
    end

    it "valid request with existing id" do
      expect(mock_connection).to receive(:get).with(url, {key: key}).and_return valid_response
      response = subject.quick_search(key)
    end

    it "with missing id" do
      expect(mock_connection).to receive(:get).with(url, {key: key}).and_return empty_response
      response = subject.quick_search(key)
    end

  end

  describe "#visitor_to_lead" do
    let(:url) { "#{service}Lead.Convert" }
    let(:values_hash) do
      {"OwnerId" => "1234567"}
    end
    let(:success_response) do
      {
        "Status" => "Success",
        "Message" => {
          "AffectedRows" => 1
        }
      }
    end
    let(:body) do
      [
        {
          "Attribute": "OwnerId",
          "Value": "1234567"
        }
      ]
    end
    let(:valid_response) { double("response", status: 200, body: success_response.to_json) }

    it "converts valid user" do
      expect(mock_connection).to receive(:post).with(url, {leadId: lead_id}, body.to_json).and_return valid_response
      response = subject.visitor_to_lead(lead_id, values_hash)
      expect(response).to eq(success_response["Status"])
    end
  end

  describe "#update" do
    let(:url) { "#{service}Lead.Update" }
    let(:new_values) do
      {phone: "1234567", city: "NY"}
    end
    let(:success_response) do
      {
        "Status" => "Success",
        "Message" => {
          "AffectedRows" => 1
        }
      }
    end
    let(:failed_response) do
      {
        "Status" => "Error",
        "ExceptionType" => "MXInvalidEntityException",
        "ExceptionMessage" => "Lead does not exist in the system"
      }
    end
    let(:body) do
      [
        {
          "Attribute": "phone",
          "Value": "1234567"
        },
        {
          "Attribute": "city",
          "Value": "NY"
        }
      ]
    end
    let(:valid_response) { double("response", status: 200, body: success_response.to_json) }
    let(:invalid_response) { double("response", status: 500, body: failed_response.to_json) }

    it "existing lead" do
      expect(mock_connection).to receive(:post).with(url, {leadId: lead_id}, body.to_json).and_return valid_response
      response = subject.update_lead(lead_id, new_values)
      expect(response).to eq(success_response["Status"])
    end

    it "missing lead" do
      expect(mock_connection).to receive(:post).with(url, {leadId: lead_id}, body.to_json).and_return invalid_response
      expect {
        subject.update_lead(lead_id, new_values)
      }.to raise_error(Leadsquared::InvalidRequestError)
    end
  end

  describe "#create_or_update" do
    let(:success_response) do
      {
        "Status" => "Success",
        "Message" => {
          "Id" => "xxxxxxxx-Lead-Idxx-xxxx-xxxxxxxxxxx",
          "AffectedRows" => 1
        }
      }
    end

    describe "search by email" do
      let(:url) { "#{service}Lead.CreateOrUpdate" }
      let(:valid_response) { double("response", status: 200, body: success_response.to_json) }
      let(:body) do
        [
        {
          "Attribute": "EmailAddress",
          "Value": email
        },
        {
          "Attribute": "SearchBy",
          "Value": "EmailAddress"
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

      it "valid request" do
        expect(mock_connection).to receive(:post).with(url, {}, body.to_json).and_return valid_response
        response = subject.create_or_update(email, attributes)
        expect(response).to eq(success_response["Message"]["Id"])
      end
    end
  end

  describe "#create_lead" do
    let(:url) { "#{service}Lead.Create" }
    let(:body) do
      [
        {
          "Attribute" => "EmailAddress",
          "Value" => email
        },
        {
          "Attribute" => "FirstName",
          "Value" => first_name
        },
        {
          "Attribute" => "LastName",
          "Value" => last_name
        }
      ]
    end
    let(:success_response) do
      {
        "Status" => "Success",
        "Message" => {
          "Id" => "3131ea6a-bb20-4457-b183-ddf6d8716dfe"
        }
      }
    end
    let(:valid_response)  { double("response", status: 200, body: success_response.to_json) }

    it "valid request with given params" do
      expect(mock_connection).to receive(:post).with(url, {}, body.to_json).and_return valid_response
      response = subject.create_lead(email, attributes)
      expect(response).to eq(success_response["Message"]["Id"])
    end

    it "invalid request" do
      expect(mock_connection).to receive(:post).with(url, {}, body.to_json).and_return invalid_response
      expect {
        subject.create_lead(email, attributes)
      }.to raise_error(Leadsquared::InvalidRequestError)
    end
  end

  describe "#get_meta_data" do
    let(:success_response) do
      [
        {
          "SchemaName" => "mx_CreationTime",
          "DisplayName" => "CreationTime",
          "DataType" => "Time",
          "IsMandatory" => false,
          "MaxLength" => "50",
          "RenderType" => 21,
          "RenderTypeTextValue" => "Time"
        },
        {
          "SchemaName" => "mx_ModifiedTime",
          "DisplayName" => "ModifiedTime",
          "DataType" => "Time",
          "IsMandatory" => false,
          "MaxLength" => "50",
          "RenderType" => 21,
          "RenderTypeTextValue" => "Time"
        }]
    end
    let(:valid_response)  { double("response", status: 200, body: success_response.to_json) }
    let(:url) { "#{service}LeadsMetaData.Get" }

    it "valid request with given params" do
      expect(mock_connection).to receive(:get).with(url, {}).and_return valid_response
      response = subject.get_meta_data
    end

  end
end

require 'json'
require 'active_support/core_ext/object/try'

module Leadsquared
  class LeadManagement
    SERVICE = '/v2/LeadManagement.svc/'.freeze

    def get_meta_data
      url = url_with_service("LeadsMetaData.Get")
      response = connection.get(url, {})
      handle_response response
    end

    def get_lead_by_id(lead_id)
      url = url_with_service("Leads.GetById")
      response = connection.get(url, {id: lead_id})
      parsed_response = handle_response response
      parsed_response.first
    end

    def get_lead_by_email(email)
      url = url_with_service("Leads.GetByEmailaddress")
      response = connection.get(url, {emailaddress: email})
      parsed_response = handle_response response
      parsed_response.first
    end

    def quick_search(key)
      url = url_with_service("Leads.GetByQuickSearch")
      response = connection.get(url, {key: key})
      handle_response response
    end

    def create_lead(email = nil, first_name = nil, last_name = nil)
      url = url_with_service("Lead.Create")
      body = [
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
      response = connection.post(url, {}, body.to_json)
      parsed_response = handle_response response
      parsed_response["Message"]["Id"]
    end

    def update_lead(lead_id, values_hash = {})
      url = url_with_service("Lead.Update")
      body = values_hash.map {|key, val| {"Attribute" => key, "Value" => val} }
      response = connection.post(url, {leadId: lead_id}, body.to_json)
      parsed_response = handle_response response
      parsed_response["Status"]
    end

    def create_or_update(email = nil, first_name = nil, last_name = nil, phone = nil, search_by = "EmailAddress")
      url = url_with_service("Lead.CreateOrUpdate")
      body = [
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
        },
        {
          "Attribute": "Phone",
          "Value": phone
        },
        {
          "Attribute": "SearchBy",
          "Value": search_by
        }
      ]
      response = connection.post(url, {}, body.to_json)
      parsed_response = handle_response response
      parsed_response["Message"]["Id"]
    end

    def visitor_to_lead(prospect_id, values_hash = {})
      url = url_with_service("Lead.Convert")
      body = values_hash.map {|key, val| {"Attribute" => key, "Value" => val} }
      response = connection.post(url, {leadId: prospect_id}, body.to_json)
      parsed_response = handle_response response
      parsed_response["Status"]
    end

    private

    def url_with_service(action)
      SERVICE + action
    end

    def connection
      @connection ||= Leadsquared::Client.new
    end

    def handle_response(response)
      case response.status
      when 200
        return JSON.parse response.body
      when 400
        raise InvalidRequestError.new("Bad Request")
      when 401
        raise InvalidRequestError.new("Unauthorized Request")
      when 404
        raise InvalidRequestError.new("API Not Found")
      when 500
        message = response.body.try(:[],  "ExceptionMessage")
        raise InvalidRequestError.new("Internal Error: #{message}")
      else
        raise InvalidRequestError.new("Unknown Error#{response.body}")
      end
    end
  end

end

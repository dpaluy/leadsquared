require 'json'
require 'active_support/core_ext/object/try'

module Leadsquared
  class Activity < ApiConnection
    SERVICE = '/v2/ProspectActivity.svc/'.freeze

    def initialize
      super(SERVICE)
    end

    def get_activities(lead_id, activity_event_id, offset = 0, row_count = 10)
      url = url_with_service("Retrieve")
      body = {
        "Parameter" => {"ActivityEvent" => activity_event_id},
        "Paging" => {"Offset" => offset, "RowCount" => row_count}
      }
      response = connection.post(url, {leadId: lead_id}, body.to_json)
      handle_response response
    end

    # direction - Use ‘1’ as direction for Outbound Activity and ‘0’ for Inbound Activity
    def create_activity_type(name, score, description, direction = 0)
      url = url_with_service("CreateType")
      body = {
        "ActivityEventName" => name,
        "Score" => score,
        "Description" => description,
        "Direction" => direction
      }
      response = connection.post(url, {}, body.to_json)
      parsed_response = handle_response response
      parsed_response["Message"]["Id"]
    end

    def post_activity

    end

    def create(email, event_id, notes = nil, first_name = nil, last_name = nil)
      url = url_with_service("Create")
      body = {
        "EmailAddress"      => email,
        "ActivityEvent"     => event_id,
        "ActivityNote"      => notes,
        "ActivityDateTime"  => current_utc_time,
        "FirstName"         => first_name,
        "LastName"          => last_name
      }
      response = connection.post(url, {}, body.to_json)
      parsed_response = handle_response response
      parsed_response["Message"]["Id"]
    end

    private

    def current_utc_time
      Time.now.utc.to_s.gsub(/ UTC$/, "")
    end
  end
end


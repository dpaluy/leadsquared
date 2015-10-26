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

    def create(activity)

    end

    def post_activity

    end

    def post_activity_with_email

    end

  end
end


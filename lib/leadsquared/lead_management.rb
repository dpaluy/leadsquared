require 'client'

module Leadsquared
  class LeadManagement
    SERVICE = '/v2/LeadManagement.svc/'.freeze
  end

  def get_meta_data
  end

  def get_lead_by_id
  end

  def get_lead_by_email
  end

  def quick_search
  end

  def create_lead(email = nil, first_name = nil, last_name = nil)
    url = url_with_service("Lead.Create")
    body = {
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
    }
    connection.post(url, {}, body)
  end

  def update_lead
  end

  def create_or_update
  end

  def visitor_to_lead
  end

  def search_lead_by_criteria
  end

  def send_email_to_lead
  end

  private

  def url_with_service(action)
    SERVICE + action
  end

  def connection
    @connection ||= Leadsquared::Client.new
  end
end

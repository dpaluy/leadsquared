module Leadsquared
  class ApiConnection
    attr_reader :connection

    def initialize(service)
      @connection = Leadsquared::Client.new
      @service = service
    end

    protected

    def url_with_service(action)
      @service + action
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
        message = response.body #.try(:[],  "ExceptionMessage")
        raise InvalidRequestError.new("Internal Error: #{message}")
      else
        raise InvalidRequestError.new("Unknown Error#{response.body}")
      end
    end

  end
end

module Leadsquared
  class InvalidRequestError < StandardError
    def initialize(error)
      super(error)
    end
  end
end

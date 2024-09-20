# frozen_string_literal: true

class NotAuthorOwnerException < StandardError
  def initialize(msg = "Author owner mismatch")
    super
  end
end

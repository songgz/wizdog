# To change this template, choose Tools | Templates
# and open the template in the editor.

module WizAuthc
  class AuthcInfo
    attr_accessor :principal, :credentials, :authenticated
    def initialize(principal = nil, credentials = nil, authenticated = false)
      @principal = principal
      @credentials = credentials
      @state = :fail
      @authenticated = authenticated
    end
  end
end

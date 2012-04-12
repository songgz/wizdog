# To change this template, choose Tools | Templates
# and open the template in the editor.

module WizAuthc
  class Authenticator
    include Singleton

    attr_accessor :storage

    def initialize
      @storage = Thread.current[:identity]
    end

    #return authentication
    def authenticate(realm)
      authentication = realm.authenticate()
      if authenticated?
        storage = nil
      end
      if authentication.authenticated?
        storage = authentication.identity
      end
      return authentication
    end

    def authenticated?

    end

  end
end

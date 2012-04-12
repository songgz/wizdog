# To change this template, choose Tools | Templates
# and open the template in the editor.
module WizAuthc
  class SecuritySession
    def initialize
    
    end

    class << self
      def controller=(value)
        Thread.current[:wiz_auth_controller] = value
      end

      ## The current controller object
      def controller
        Thread.current[:wiz_auth_controller]
      end
    end

    private
    def controller
      self.class.controller
    end
  end
end

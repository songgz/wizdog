# To change this template, choose Tools | Templates
# and open the template in the editor.
module WizAuthc
  module Filter
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        attr_accessor :current
        include InstanceMethods
        before_filter :activate_wiz_auth

      end
    end

    module ClassMethods

    end


    module InstanceMethods

      def authenticated?
        WizAuthc::SecurityContext.current.authenticated?
      end

      private
      def activate_wiz_auth
        p self.session.to_s
        WizAuthc::SecurityContext.init(self)
        @current = WizAuthc::SecurityContext.current
      end
    end
  end
end

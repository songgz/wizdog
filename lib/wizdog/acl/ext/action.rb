# To change this template, choose Tools | Templates
# and open the template in the editor.

module WizAcl
  module Action
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        include InstanceMethods
        before_filter :allowed?
      end
    end
    
    module ClassMethods
      def allow(aros = "*", actions = "*")
        Acl.instance.allow(aros, controller_name, actions)
      end

      def deny(aros = "*", actions = "*")
        Acl.instance.allow(aros, controller_name, actions)
      end

      def current_aro
        session[:current_user]
      end
    end
    
    module InstanceMethods
      def aco_id
        self.class.controller_name
      end

      def allow(aros = "*", actions = "*")
        Acl.instance.allow(aros, self, actions)
      end

      def deny(aros = "*", actions = "*")
        Acl.instance.deny(aros, self, actions)
      end

      def allowed?
        Acl.instance.allowed?(self.class.current_aro, self, action_name)
      end

    end
  end
end

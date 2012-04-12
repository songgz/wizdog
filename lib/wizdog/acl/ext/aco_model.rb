# To change this template, choose Tools | Templates
# and open the template in the editor.
module WizAcl
  module AcoModel
    def self.included(base)      
      base.class_eval do
        include InstanceMethods
      end
    end

    module InstanceMethods
      def aco_id
        "#{self.class.name}_#{id}"
      end

      def allow(aros = "*", operations = "*")
        Acl.instance.allow(aros, self, operations)
      end

      def deny(aros = "*", operations = "*")
        Acl.instance.deny(aros, self, operations)
      end

      def allowed?(aros = "*", operation = "*")
        Acl.instance.allowed?(aros, self, operation)
      end

      def remove_allow(aros = "*", operations = "*")
        Acl.instance.remove_allow(aros, self, operations)
      end

      def find_entries
        Acl.instance.find_entries_by_aco(self)
      end

    end
  end
end

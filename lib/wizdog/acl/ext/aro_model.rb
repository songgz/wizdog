# To change this template, choose Tools | Templates
# and open the template in the editor.

module WizAcl
  module AroModel
    def self.included(base)
      base.class_eval do
        include InstanceMethods
      end
    end

    module ClassMethods
      def allow(acos = "*", operations = "*")
        Acl.instance.allow(self.name, acos, operations)
      end

      def deny(acos = "*", operations = "*")
        Acl.instance.allow(self.name, acos, operations)
      end
    end

    module InstanceMethods
      def aro_id
        "#{self.class.name}_#{id}"
      end

      def allow(acos = "*", operations = "*")
        Acl.instance.allow(self, acos, operations)
      end

      def deny(acos = "*", operations = "*")
        Acl.instance.allow(self, acos, operations)
      end

      def allowed?(acos = "*", operation = "*")
        Acl.instance.allowed?(self, acos, operation) || Acl.instance.allowed?(self.class.name, acos, operation)
      end

      def find_entries
        Acl.instance.find_entries_by_aro(self)
      end

    end
  end
end

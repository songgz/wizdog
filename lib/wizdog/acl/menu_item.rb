module WizAcl
  class MenuItem < Aco
    attr_accessor :url
    alias_attribute :id, :aco_id

    def initialize(attributes = {})
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end

    def add(attributes = nil)
      acl = WizAcl::Acl.instance
      case attributes
        when Hash
          acl.add_aco(WizAcl::MenuItem.new(attributes), self)
        when Array
          attributes.each do |attribute|
            add(attribute)
          end
        when WizAcl::Aco
          acl.add_aco(attributes, self)
        else
      end
    end
  end
end
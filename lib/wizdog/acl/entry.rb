# To change this template, choose Tools | Templates
# and open the template in the editor.

module WizAcl
  class Entry
    attr_accessor :aro_id, :aco_id, :privileges

    def initialize(aro = "*", aco = "*")
      aro.respond_to?(:aro_id) ? @aro_id = aro.aro_id : @aro_id = aro.to_s
      aco.respond_to?(:aco_id) ? @aco_id = aco.aco_id : @aco_id = aco.to_s
      #{:operation => :permission}
      @privileges = {}
    end   

    def allow(operations = "*")
      #@privileges << Privilege.new(operation, :allow)
      privilege(operations, :allow)
      return self
    end

    def deny(operations = "*")
      #@privileges << Privilege.new(operation, :deny)
      privilege(operations, :deny)
      return self
    end

    def allowed?(operation = "*")
      permission = @privileges[operation.to_s] || @privileges["*"]
      return permission == :allow unless permission.nil?
      nil
    end

    private
    
    def privilege(operations = "*", permission = :deny)
      operations = operations.to_a unless operations.is_a?(Array)
      operations.each do |operation|
        @privileges[operation.to_s] = permission
      end
    end
  end
end

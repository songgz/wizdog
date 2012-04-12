# To change this template, choose Tools | Templates
# and open the template in the editor.
module WizAcl
  class Aco
    attr_accessor :aco_id, :name

    def initialize(id = "*")
      @aco_id = id
    end

    def aro_parents
      {}
    end
    
  end
end
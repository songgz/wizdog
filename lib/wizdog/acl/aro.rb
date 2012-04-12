# To change this template, choose Tools | Templates
# and open the template in the editor.

module WizAcl
  class Aro
    attr_accessor :aro_id
    
    def initialize(id = "*")
      @aro_id = id
    end

    def aro_parents
      {}
    end
  end
end

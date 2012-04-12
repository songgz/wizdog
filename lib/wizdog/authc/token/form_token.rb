# To change this template, choose Tools | Templates
# and open the template in the editor.

module WizAuthc
  class FormToken < AuthcToken
    def initialize(login_name, password)
      self.principal = login_name
      self.credentials = password
    end
  end
end

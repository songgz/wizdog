# To change this template, choose Tools | Templates
# and open the template in the editor.

module WizAuthc
  class RailsEnv < WebEnv
    def session
      self.env.session
    end

    def cookies
      self.env.send(:cookies)
    end

    def request
      self.env.request
    end
  end
end

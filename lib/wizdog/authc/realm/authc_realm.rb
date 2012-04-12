# To change this template, choose Tools | Templates
# and open the template in the editor.

module WizAuthc
  module AuthcRealm
    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        include InstanceMethods
      end
    end

    module ClassMethods
      def find_one_by_principal(principal)
        first(:conditions => {:login => principal})
      end

      def authenticate(token, remembered = false)
        user = find_one_by_principal(token.principal)
        info = AuthcInfo.new()
        if user && user.authenticate(token.credentials)
          info.principal = {:identity => user.id, :type => user.class}
          info.credentials = token.credentials
          info.authenticated = true
        end
        return info
      end
    end

    module InstanceMethods
      attr_accessor :password, :password_confirmation
      
      def authenticate(credential = nil)
        self.credential == encrypt(credential)
      end

      # Encrypts the password with the user salt
      def encrypt(password)
        Digest::SHA1.hexdigest("--#{salt}--#{password}--")
      end

      def encrypt_password
        self.password = '123456' if password.blank?
        self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
        self.crypted_password = encrypt(password)
      end
    end
  end
end

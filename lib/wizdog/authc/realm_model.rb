# To change this template, choose Tools | Templates
# and open the template in the editor.

module WizAuthc
  module RealmModel
    def self.included(base)      
      base.extend(ClassMethods)
      base.class_eval do        
        include InstanceMethods
      end
    end

    module ClassMethods
      #      @@realm_map = {:principal => :name, :credential => :password, :remembered => false}
      #:credential
      # :principal
      # :remembered
      # @@realm_map = {}
      
      #      def set_realm_map(options = nil)
      #        #        return unless options.is_a?(Hash)
      #        @@realm_map = @@realm_map.merge(options)
      #        #        principal = options[:principal]
      #        #        alias principal :principal
      #        #        credential = options[:credential]
      #        #        alias credential :credential
      #
      #      end
      #
      #      def get_realm_map
      #        @@realm_map
      #      end
      #
      def find_by_principal(principal)
        where(:login => principal).first
      end

      def authenticate(principal=nil, credential=nil, remembered = false)
        if respond_to?(:find_one_by_principal)
          user = find_one_by_principal(principal)
        else
          user = find_by_principal(principal)
        end
        user && user.authenticate(credential) ? user : nil
      end

    end

    module InstanceMethods
      #attr_accessor :password, :password_confirmation
      def authenticate(credential = nil)
        self.credential == encrypt(credential)
        #        realm_map = self.class.get_realm_map
        #        my_principal = realm_map[:principal]
        #        my_credential = realm_map[:credential]
        #        if self.respond_to?(my_principal) && self.respond_to?(my_credential)
        #          if principal == self.send(my_principal) && credential == self.send(my_credential)
        #            return self.send(my_principal)
        #          end
        #        end
      end

#      attr_accessor :password, :password_confirmation



      # Encrypts the password with the user salt
      def encrypt(password)
        Digest::SHA1.hexdigest("--#{salt}--#{password}--")
      end

      def encrypt_password
        if new_record?
          self.password = '123456' if self.password.blank?
          self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--")
          self.password = encrypt(self.password)
        end
      end
    end
  end
end

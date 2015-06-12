# To change this template, choose Tools | Templates
# and open the template in the editor.

module WizAuthc
  class SecurityContext    
#    @@ip = "0.0.0.0"
#    @@contexts = {}
    class << self
      def env
        Thread.current[:security_env_key]
      end

      def env=(value)
        Thread.current[:security_env_key] = value
      end

#      def context
#        Thread.current[:security_context_key]
#      end

      def current=(value)
#        Thread.current[:security_context_key] = value
         Thread.current[:security_contexts_key] = value
      end

      def session
        env.session[:security_session_key] ||= {}
      end
#
#      def session=(value)
#        Thread.current[:security_session_key] = value
#      end

      def current
        Thread.current[:security_contexts_key]
      end

      def init(env, current)
        self.env = env
        self.current = current
      end





      #--------------------------
      
      def authenticate(realm, token)
        authc_info = realm.authenticate(token)
#        ctx = self.current
#        unless ctx
#          session = ctx.session
#        end
        ctx = self.new(authc_info.principal, authc_info.authenticated, env.session)
#        env.session[:security_contexts_key] = ctx
        self.current = ctx
      end


    end

    attr_accessor :principal, :authenticated, :session
    
    def initialize(principal, authenticated = nil, session = nil, ip = nil)
      @principal = principal || nil
      @authenticated = authenticated || false
      @session = session
      @ip = ip || "0.0.0.0"
      @actived = false
    end

    def authenticated?
      @authenticated
    end

    def user
      @principal[:type].constantize.find(@principal[:identity])
    end
  end
end

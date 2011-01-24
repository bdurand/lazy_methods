# Including this module will provide the lazy method handling for the class where any method can be
# prefixed with lazy_ to defer execution. By default, the plugin includes it in Object so it is universally
# available.
module LazyMethods
  
  module InstanceMethods
    def self.included (base)
      base.send :alias_method, :method_missing_without_lazy, :method_missing
      base.send :alias_method, :method_missing, :method_missing_with_lazy
    end
    
    # Override missing method to add the lazy method handling
    def method_missing_with_lazy (method, *args, &block)
      method = method.to_s
      if method[0, 5] == 'lazy_'
        method = method.to_s
        called_method = method[5, method.length]
        return Proxy.new(self, called_method, args, &block)
      else
        # Keep track of the current missing method calls to keep out of an infinite loop
        stack = Thread.current[:lazy_method_missing_methods] ||= []
        sig = MethodSignature.new(self, method)
        raise NoMethodError.new("undefined method `#{method}' for #{self}") if stack.include?(sig)
        begin
          stack.push(sig)
          return method_missing_without_lazy(method, *args, &block)
        rescue Exception => e
          # Strip this method from the stack trace as it adds confusion
          e.backtrace.reject!{|line| line.include?(__FILE__)}
          raise e
        ensure
          stack.pop
        end
      end
    end
  end
  
  # This class is used to keep track of methods being called.
  class MethodSignature
    
    attr_reader :object, :method
    
    def initialize (obj, method)
      @object = obj
      @method = method
    end
    
    def eql? (sig)
      sig.kind_of(MethodSignature) && sig.object == @object && sig.method == @method
    end
    
  end
  
  # The proxy object does all the heavy lifting.
  class Proxy
    # These methods we don't want to override. All other existing methods will be redefined.
    PROTECTED_METHODS = %w(initialize method_missing __proxy_result__ __proxy_loaded__ __send__ __id__ object_id)
    
    # Override already defined methods on Object to proxy them to the result object
    instance_methods.each do |m|
      undef_method(m) unless PROTECTED_METHODS.include?(m.to_s)
    end
    
    def initialize (obj, method, args = nil, &block)
      @object = obj
      @method = method
      @args = args || []
      @block = block
    end
    
    # Get the result of the original method call. The original method will only be called once.
    def __proxy_result__
      @proxy_result = @object.send(@method, *@args, &@block) unless defined?(@proxy_result)
      @proxy_result
    end
    
    # Helper method that indicates if the proxy has loaded the original method results yet.
    def __proxy_loaded__
      !!defined?(@proxy_result)
    end
    
    # All missing methods are proxied to the original result object.
    def method_missing (method, *args, &block)
      __proxy_result__.send(method, *args, &block)
    end
  end
  
end

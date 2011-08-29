require 'thread'

# Include this module in classes you wish to add lazy or asynchronous methods to.
#
# To define a lazy or asynchronous methods methods:
#
#   class MyClass
#     include LazyMethods
#
#     define_lazy_methods :method_1, :method_2
#     define_async_methods :method_3, :method_4
#
#     define_lazy_class_methods :class_method_1
#     define_async_class_methods :class_method_2
#
#     ...
#   end
#
# This will allow you to call the methods as
#
#   obj = MyClass.new
#
#   obj.lazy_method_1
#   obj.lazy_method_2
#
#   obj.async_method_3
#   obj.async_method_4
#
#   MyClass.lasy_class_method_1
#   MyClass.async_class_method_2
module LazyMethods
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods
    def define_lazy_methods(*method_names)
      method_names.flatten.each do |method_name|
        class_eval <<-EOS
          def lazy_#{method_name}(*args, &block)
            LazyProxy.new{ #{method_name}(*args, &block) }
          end
        EOS
      end
    end
    
    def define_async_methods(*method_names)
      method_names.flatten.each do |method_name|
        class_eval <<-EOS
          def async_#{method_name}(*args, &block)
            AsyncProxy.new{ #{method_name}(*args, &block) }
          end
        EOS
      end
    end
    
    def define_lazy_class_methods(*method_names)
      method_names.flatten.each do |method_name|
        class_eval <<-EOS
          def self.lazy_#{method_name}(*args, &block)
            LazyProxy.new{ #{method_name}(*args, &block) }
          end
        EOS
      end
    end
    
    def define_async_class_methods(*method_names)
      method_names.flatten.each do |method_name|
        class_eval <<-EOS
          def self.async_#{method_name}(*args, &block)
            AsyncProxy.new{ #{method_name}(*args, &block) }
          end
        EOS
      end
    end
  end
  
  # The proxy object does all the heavy lifting.
  class Proxy #:nodoc:
    # These methods we don't want to override. All other existing methods will be redefined.
    PROTECTED_METHODS = %w(initialize method_missing __proxy_result__ __proxy_loaded__ __send__ __id__ object_id)
    
    # Override already defined methods on Object to proxy them to the result object
    instance_methods.each do |m|
      undef_method(m) unless PROTECTED_METHODS.include?(m.to_s)
    end
        
    # All missing methods are proxied to the original result object.
    def method_missing(method, *args, &block)
      __proxy_result__.send(method, *args, &block)
    end
  end
  
  class LazyProxy < Proxy #:nodoc:
    def initialize(&block)
      @method_call = block
    end
    
    # Get the result of the original method call. The original method must only be called once.
    def __proxy_result__
      @proxy_result = @method_call.call unless defined?(@proxy_result)
      @proxy_result
    end
    
    # Helper method that indicates if the proxy has loaded the original method results yet.
    def __proxy_loaded__
      !!defined?(@proxy_result)
    end
  end
  
  class AsyncProxy < Proxy #:nodoc:
    def initialize(&block)
      @proxy_result = nil
      @proxy_exception = nil
      if defined?(Thread.critical) && Thread.critical
        @proxy_result = block.call
      else
        @thread = Thread.new do
          begin
            @proxy_result = block.call
          rescue Exception => e
            @proxy_exception = e
          end
        end
      end
    end
    
    # Get the result of the original method call. The original method will only be called once.
    def __proxy_result__
      @thread.join if @thread && @thread.alive?
      @thread = nil
      raise @proxy_exception if @proxy_exception
      return @proxy_result
    end
    
    def __proxy_loaded__
      !(@thread && @thread.alive?)
    end
  end
end

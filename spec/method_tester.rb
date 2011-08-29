# This class is used for testing the lazy_methods functionality.

class LazyMethods::Tester
  include LazyMethods
  
  attr_reader :test_method_called
  
  define_lazy_methods :test_method, :to_s
  define_async_methods :test_method, :to_s
  define_lazy_class_methods :test_class_method, :to_s
  define_async_class_methods :test_class_method, :to_s
  
  def initialize
    @test_method_called = 0
    @lazy_real_method_called = false
  end
  
  def test_method(arg)
    sleep(0.02)
    @test_method_called += 1
    yield if block_given?
    arg.upcase if arg
  end
  
  class << self
    attr_accessor :test_class_method_called
    
    def test_class_method(arg)
      sleep(0.02)
      @test_class_method_called = (self.test_class_method_called || 0) + 1
      yield if block_given?
      arg.upcase if arg
    end
  end  
end

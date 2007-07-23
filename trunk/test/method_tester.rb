# This class is used for testing the lazy_methods plugin functionality.

class MethodTester
  
  attr_reader :test_called, :lazy_real_method_called
  
  def initialize
    @test_called = 0
    @lazy_real_method_called = false
  end
  
  def test (arg)
    @test_called += 1
    yield if block_given?
    arg.upcase if arg
  end
  
  def lazy_real_method
    @lazy_real_method_called = true
  end
  
  def method_missing (method, *args, &block)
    if method.to_s.starts_with?('find_')
      yield if block_given?
      "FINDER"
    else
      super
    end
  end
  
end

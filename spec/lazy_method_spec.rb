require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'lazy_methods', 'lazy_methods'))
Object.send(:include, LazyMethods::InstanceMethods) unless Object.include?(LazyMethods::InstanceMethods)
require File.expand_path(File.dirname(__FILE__) + '/method_tester')

context "LazyMethods InstanceMethods" do
  
  let(:object) { MethodTester.new }
  
  specify "should inject lazy method handling" do
    proxy = object.lazy_test("arg")
    proxy.to_s.should == "ARG"
    proxy.__proxy_loaded__.should == true
  end
  
  specify "should return a proxy object that has not been invoked yet" do
    proxy = object.lazy_test("arg")
    proxy.__proxy_loaded__.should == false
  end
  
end

context "LazyMethods Proxy" do
  
  let(:object) { MethodTester.new }
  
  specify "should be able to wrap a method without executing it" do
    proxy = object.lazy_test("arg")
    object.test_called.should == 0
  end
  
  specify "should execute the wrapped method when it needs to" do
    proxy = object.lazy_test("arg")
    proxy.to_s
    object.test_called.should == 1
  end
  
  specify "should only execute the wrapped method once" do
    proxy = object.lazy_test("arg")
    proxy.to_s
    proxy.to_s
    object.test_called.should == 1
  end
  
  specify "should allow nil as a valid proxied value" do
    proxy = object.lazy_test(nil)
    proxy.should_not
    object.test_called.should == 1
  end
  
  specify "should allow blocks in the lazy method" do
    n = 1
    proxy = object.lazy_test("arg") do
      n = 2
    end
    n.should == 1
    proxy.to_s
    n.should == 2
  end
  
  specify "should be indistinguishable from the real object" do
    proxy = object.lazy_test("arg")
    proxy.class.should == String
    proxy.kind_of?(String).should == true
  end
  
  specify "should proxy core methods on Object" do
    proxy = "xxx".lazy_to_s
    proxy.should == "xxx"
  end
  
  specify "should proxy missing methods" do
    proxy = object.lazy_find_test
    proxy.to_s.should == "FINDER"
  end
  
  specify "should allow blocks in the lazy missing methods" do
    n = 1
    proxy = object.lazy_find_test do
      n = 2
    end
    n.should == 1
    proxy.to_s
    n.should == 2
  end
  
  specify "should not interfere with the proxied object's method_missing" do
    real = object.find_test
    real.to_s.should == "FINDER"
  end
  
  specify "should not interfere with real methods that begin with lazy_" do
    object.lazy_real_method_called.should == false
    object.lazy_real_method
    object.lazy_real_method_called.should == true
  end
  
end

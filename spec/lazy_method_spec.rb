require 'spec_helper'

describe LazyMethods do
  context "lazy methods" do
    let(:object){ LazyMethods::Tester.new }
    
    it "should define a lazy version of a method" do
      proxy = object.lazy_test_method("woo")
      object.test_method_called.should == 0
      proxy.should == "WOO"
      object.test_method_called.should == 1
      proxy.to_s
      object.test_method_called.should == 1
    end
    
    it "should define a lazy version of a method that takes a block" do
      block_evaled = false
      proxy = object.lazy_test_method("woo"){ block_evaled = !block_evaled }
      object.test_method_called.should == 0
      block_evaled.should == false
      proxy.should == "WOO"
      object.test_method_called.should == 1
      block_evaled.should == true
      proxy.to_s
      object.test_method_called.should == 1
      block_evaled.should == true
    end
    
    it "should define a lazy version of a class method" do
      LazyMethods::Tester.test_class_method_called = 0
      block_evaled = false
      proxy = LazyMethods::Tester.lazy_test_class_method("woo"){ block_evaled = !block_evaled }
      LazyMethods::Tester.test_class_method_called.should == 0
      block_evaled.should == false
      proxy.should == "WOO"
      LazyMethods::Tester.test_class_method_called.should == 1
      block_evaled.should == true
      proxy.to_s
      LazyMethods::Tester.test_class_method_called.should == 1
      block_evaled.should == true
    end
  end
  
  context "async methods" do
    let(:object){ LazyMethods::Tester.new }
    
    it "should define an asynchronous version of a method" do
      proxy = object.async_test_method("woo")
      object.test_method_called.should == 0
      sleep(0.2)
      object.test_method_called.should == 1
      proxy.should == "WOO"
      proxy.to_s
      object.test_method_called.should == 1
    end
    
    it "should define an asynchronous version of a method that takes a block" do
      block_evaled = false
      proxy = object.async_test_method("woo"){ block_evaled = !block_evaled }
      object.test_method_called.should == 0
      block_evaled.should == false
      sleep(0.2)
      object.test_method_called.should == 1
      block_evaled.should == true
      proxy.should == "WOO"
      proxy.to_s
      object.test_method_called.should == 1
      block_evaled.should == true
    end
    
    it "should define an asynchronous version of a class method" do
      LazyMethods::Tester.test_class_method_called = 0
      block_evaled = false
      proxy = LazyMethods::Tester.async_test_class_method("woo"){ block_evaled = !block_evaled }
      LazyMethods::Tester.test_class_method_called.should == 0
      block_evaled.should == false
      sleep(0.2)
      LazyMethods::Tester.test_class_method_called.should == 1
      block_evaled.should == true
      proxy.should == "WOO"
      proxy.to_s
      LazyMethods::Tester.test_class_method_called.should == 1
      block_evaled.should == true
    end
  end
end

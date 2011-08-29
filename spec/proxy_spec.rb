require 'spec_helper'

describe LazyMethods::LazyProxy do
  it "should wrap a block and proxy all methods to the result" do
    proxy = LazyMethods::LazyProxy.new{ "xyz" }
    proxy.size.should == 3
    proxy.to_sym.should == :xyz
    proxy.is_a?(String).should == true
    proxy.should == "xyz"
  end
  
  it "should not evaluate the block until a method is called on it" do
    value = "test"
    proxy = LazyMethods::LazyProxy.new{ value << " called" }
    value.should == "test"
    proxy.should == "test called"
    value.should == "test called"
  end
  
  it "should only evaluate the block once" do
    value = "test"
    proxy = LazyMethods::LazyProxy.new{ value << " called" }
    value.should == "test"
    proxy.should == "test called"
    proxy.should == "test called"
    proxy.should == "test called"
  end
  
  it "should be able to wrap nil" do
    proxy = LazyMethods::LazyProxy.new{ nil }
    proxy.should == nil
    proxy.nil?.should == true
  end
  
  it "should tell if the block has been evaluated" do
    proxy = LazyMethods::LazyProxy.new{ "xyz" }
    proxy.__proxy_loaded__.should == false
    proxy.to_s
    proxy.__proxy_loaded__.should == true
  end
end

describe LazyMethods::AsyncProxy do
  it "should wrap a block and proxy all methods to the result" do
    proxy = LazyMethods::AsyncProxy.new{ "xyz" }
    proxy.size.should == 3
    proxy.to_sym.should == :xyz
    proxy.is_a?(String).should == true
    proxy.should == "xyz"
  end
  
  it "should not block on evaluating the block until a method is called on it" do
    value = "test"
    proxy = LazyMethods::AsyncProxy.new{ sleep(0.25); value << " called" }
    proxy.__proxy_loaded__.should == false
    value.should == "test"
    proxy.should == "test called"
    value.should == "test called"
  end
  
  it "should only evaluate the block once" do
    value = "test"
    proxy = LazyMethods::AsyncProxy.new{ sleep(0.25); value << " called" }
    value.should == "test"
    proxy.should == "test called"
    proxy.should == "test called"
    proxy.should == "test called"
  end
  
  it "should be able to wrap nil" do
    proxy = LazyMethods::AsyncProxy.new{ nil }
    proxy.should == nil
    proxy.nil?.should == true
  end
  
  it "should tell if the block has been evaluated" do
    proxy = LazyMethods::AsyncProxy.new{ sleep(0.25); "xyz" }
    proxy.__proxy_loaded__.should == false
    proxy.to_s
    proxy.__proxy_loaded__.should == true
  end
  
  if defined?(Thread.critical)
    it "should not open a new thread if Thread.critical is true" do
      Thread.should_receive(:new)
      proxy = LazyMethods::AsyncProxy.new{ "abc" }
      proxy.to_s
    
      begin
        Thread.critical = true
        Thread.should_not_receive(:new)
        proxy = LazyMethods::AsyncProxy.new{ "xyz" }
        proxy.should == "xyz"
      ensure
        Thread.critical = false
      end
    end
  end
end

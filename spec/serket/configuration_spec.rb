require "spec_helper"

describe Serket::Configuration do
  describe 'defaults' do
    before :each do
      @configuration = Serket::Configuration.new
    end

    it "should have a default encoding of utf-8" do
      @configuration.encoding.should == 'utf-8'
    end

    it "should have a default delimiter of ::" do
      @configuration.delimiter.should == '::'
    end

    it "should have a default format of delimited" do
      @configuration.format.should == :delimited
    end

    it "should have a default symmetric algorithm of AES-256-CBC" do
      @configuration.symmetric_algorithm.should == 'AES-256-CBC'
    end
  end

  describe 'configuration changes' do
    it "should allow a configuration change for encoding" do
      Serket.configure do |config|
        config.encoding = 'utf-16'
      end

      Serket.configuration.encoding.should == 'utf-16'
    end

    it "should allow a configuration change for format" do
      Serket.configure do |config|
        config.format = :json
      end

      Serket.configuration.format.should == :json
    end

    it "should allow a configuration change for delimiter" do
      Serket.configure do |config|
        config.delimiter = '**'
      end

      Serket.configuration.delimiter.should == '**'
    end

    it "should allow a configuration change for symmetric_algorithm" do
      Serket.configure do |config|
        config.symmetric_algorithm = 'AES-128-CBC'
      end

      Serket.configuration.symmetric_algorithm.should == 'AES-128-CBC'
    end

    after :each do
      Serket.configure do |config|
        config.delimiter = '::'
        config.format = :delimited
        config.encoding = 'utf-8'
        config.symmetric_algorithm = 'AES-256-CBC'
      end
    end
  end
end

require 'spec_helper'

describe Serket::FieldDecrypter do
  before :all do
    @encrypted_message = 'RC78JOorP4EKyuh3Bh9atg==::iiaRmPaoFbke5d81FkL5SgQYudtnV2rl370QVlJel0f2+IniSugQ359gvsTqT2YPg1JcZ+9eky9GLGoDdAX90jsqYBG3CnawS6FgHNfO2HxBxTcgTWgfRmZv1lLo4JJ423lVXMdQv2mxgBTTMMO1ZNJsHtDjOoKlTGPh1lL3DARRrkz67J8LKN/zGDMIQXr9kfag/qkCJgJB36Owsj+9qIKKrzxtznsp/t8/Q2JGaKJmvh0srKr35hXJ6+cucI/+2uhEE78oKadUTyxxzgKrrmhKkKW2TvO4BPRsA7kpU6/X44UYYxQ2eqiMrhvklbzZKgtOuk84LZg4gXi9zCc80g==::gPYO7iDShmrk+RzO5ydjMfSUizmVEA6dAdrpsLeZvqI=' 

  end

  before :each do
    @field_decrypter = Serket::FieldDecrypter.new
  end

  it "should correctly decrypt a message" do
    @field_decrypter.decrypt(@encrypted_message).should == "Hello out there!"
  end

  it "should return nil for a blank string" do
    @field_decrypter.decrypt(' ').should be_nil
  end

  it "should allow a change in field delimiter" do
    @field_decrypter.field_delimiter = '**'
    @field_decrypter.field_delimiter.should == '**'
    asterik_delimited = @encrypted_message.gsub(/:/, '*')
    @field_decrypter.decrypt(asterik_delimited).should == "Hello out there!"
  end

  it "should not allow a base64 character as a delimiter" do
    [*('a'..'z'), *('A'..'Z'), *('0'..'9'), '+', '/'].each do |char|
      expect { @field_decrypter.field_delimiter = char }.to raise_error
    end
  end

  describe "json parsing" do
    before :each do
      @field_decrypter_json = Serket::FieldDecrypter.new(format: :json)
      iv, key, message = @encrypted_message.split(@field_decrypter.field_delimiter)
      @message = {}
      @message['iv'] = iv
      @message['key'] = key 
      @message['message'] = message 
    end

    it "should parse a json field" do
      iv, key, m = @field_decrypter_json.send(:parse, @message.to_json)
      iv.should  == @message['iv']
      key.should == @message['key']
      m.should   == @message['message']
    end

    it "should decrypt a json value" do
      @field_decrypter_json.decrypt(@message.to_json).should == "Hello out there!"
    end
  end
end

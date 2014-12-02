require 'spec_helper'

describe Serket::FieldEncrypter do
  before :each do
    @field_encrypter = Serket::FieldEncrypter.new
    @field_decrypter = Serket::FieldDecrypter.new
  end

  it "should correctly encrypt/decrypt a message" do
    encrypted_text = @field_encrypter.encrypt("Hello out there!")
    @field_decrypter.decrypt(encrypted_text).should == "Hello out there!" 
  end

  it "should not allow a base64 character as a delimiter" do
    [*('a'..'z'), *('A'..'Z'), *('0'..'9'), '+', '/'].each do |char|
      expect { @field_encrypter.field_delimiter = char }.to raise_error
    end
  end

  it "should return nil if the empty string is encrypted" do
    @field_encrypter.encrypt('').should be_nil
  end

  describe "json parsing" do
    before :each do
      @field_encrypter_json = Serket::FieldEncrypter.new(format: :json)
      @encrypted_json = @field_encrypter_json.encrypt("Hello out there!")
      @parsed_json = JSON.parse(@encrypted_json)
    end

    it "should have the correct json fields" do
      @parsed_json.has_key?('iv').should be_true
      @parsed_json.has_key?('key').should be_true
      @parsed_json.has_key?('message').should be_true
    end
  end

  describe "encoding" do
    it "should encrypt and decrypt an accent character" do
      characters = %w(á é í ó ú ü ñ ¿ ¡)
      characters.each do |c|
        encrypted = @field_encrypter.encrypt(c)
        decrypted = @field_decrypter.decrypt(encrypted)
        c.should == decrypted
      end
    end

    it "should encrypt and decrypt khmer" do
      characters = %w(ឃ  ង ទ ម វ ស )
      characters.each do |c|
        encrypted = @field_encrypter.encrypt(c)
        decrypted = @field_decrypter.decrypt(encrypted)
        c.should == decrypted
      end
    end
  end
end

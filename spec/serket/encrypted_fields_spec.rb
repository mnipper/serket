require "spec_helper"

describe Serket::EncryptedFields do
  describe 'field encryption' do
    before :each do
      @encrypted_model = Serket::EncryptedModel.new
    end

    it "should encrypt a plaintext field" do
      field_decrypter = Serket::FieldDecrypter.new
      @encrypted_model.email = 'kemba.walker@aol.com'
      decrypted = field_decrypter.decrypt(@encrypted_model.email)
      decrypted.should == 'kemba.walker@aol.com'
    end
  end
end

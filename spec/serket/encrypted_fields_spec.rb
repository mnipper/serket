require "spec_helper"

describe Serket::EncryptedFields do
  describe 'field encryption' do
    before :each do
      @encrypted_model = Serket::EncryptedModel.new
    end

    it "should encrypt a plaintext field" do
      @encrypted_model.email = 'kemba.walker@aol.com'
      decrypted = Serket.decrypt(@encrypted_model.email)
      decrypted.should == 'kemba.walker@aol.com'
    end
  end
end

require "spec_helper"

describe Serket::DecryptedFields do
  describe 'field decryption' do
    before :each do
      @encrypted_model = Serket::EncryptedModel.new
    end

    it "should decrypt an encrypted name" do
      encrypted_name = 'bm5gkjwdfv6QBUqFPEnOaw==::CtQJyXdbuLeVzmIOIr0h/F9yh7xvz5KWUgxe/u4IkORGOW4KjU4bw+Wzve2vV1nLYUEWJJprr8sb+grm+Ao2sngNejiHzSkJKqZA/Pclw/Ok8KgHgN7olUz4BoCSdivIDRIT9ar06sNBrqOvLd4iGUlpMkpLdSJ69K08ebSvg5tED+PcK/oI6SJoVxRoUMYdYa9AfeIS9Ld5BgvhsaJgCKr089kfH2CzwpzlmRfdxb2qgyDXnk9PG/4WUEjjbamF/R74FNBdWkTLxZeLGdMImh87CQ6AOJ/v8l1JSzpPWwEjtmhTbFEzJPuA01tP5U5D07si0esJnab/B48iACEoLg==::iSmdDgnTzkEUv0yLbtFa8Q=='
      @encrypted_model.name = encrypted_name
      @encrypted_model.name.should == 'Kemba Walker'
    end
  end
end

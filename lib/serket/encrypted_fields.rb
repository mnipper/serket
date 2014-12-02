module Serket
  module EncryptedFields
    def encrypted_fields(*fields)
      fields.each do |field|
        define_method("#{field}=") do |value|
          write_attribute(field, Serket.field_encrypter.encrypt(value))
        end
      end
    end
  end
end

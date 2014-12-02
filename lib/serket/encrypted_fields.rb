module Serket
  module EncryptedFields
    def encrypted_fields(*fields)
      field_encrypter = FieldEncrypter.new

      fields.each do |field|
        define_method("#{field}=") do |value|
          write_attribute(field, field_encrypter.encrypt(value))
        end
      end
    end
  end
end

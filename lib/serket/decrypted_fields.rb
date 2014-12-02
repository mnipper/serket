module Serket
  module DecryptedFields
    def decrypted_fields(*fields)
      field_decrypter = FieldDecrypter.new

      fields.each do |field|
        define_method("#{field}=") do |value|
          write_attribute(field, field_decrypter.decrypt(value))
        end
      end
    end
  end
end

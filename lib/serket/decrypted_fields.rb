module Serket
  module DecryptedFields
    def decrypted_fields(*fields)
      fields.each do |field|
        define_method("#{field}=") do |value|
          write_attribute(field, Serket.field_decrypter.decrypt(value))
        end
      end
    end
  end
end

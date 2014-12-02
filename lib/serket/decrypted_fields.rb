module Serket
  # If a class extends DecryptedFields, then the getter method will be overridden
  # for each attribute that is listed.
  #
  # For example:
  #
  # class Person
  #   extend Serket::DecryptedFields
  #
  #   decrypted_fields :name, :email
  # end
  #
  # This will create a method name=(value) and email=(value)
  #
  # It assumes the encrypted name and email will be assigned to an
  # instance of person, and will automatically decrypt the encrypted
  # value using the configured private key.
  #
  # This currently relies on the write_attribute, which is available in
  # ActiveRecord::Base.  This currently is only intended for use with rails.
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

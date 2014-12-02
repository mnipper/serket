module Serket
  # If a class extends EncryptedFields, then the getter method will be overridden
  # for each attribute that is listed.
  #
  # For example:
  #
  # class Person
  #   extend Serket::EncryptedFields
  #
  #   encrypted_fields :name, :email
  # end
  #
  # This will create a method name=(value) and email=(value)
  #
  # When a value is assigned to name or email for a given person instance,
  # it will automatically generate an encrypted version using the
  # currently configured public key, and will store the cipher text instead
  # of the plaintext value that was assigned.
  #
  # This currently relies on the write_attribute, which is available in
  # ActiveRecord::Base.  This currently is only intended for use with rails.
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

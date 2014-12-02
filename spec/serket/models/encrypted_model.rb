require 'spec_helper'

class Serket::EncryptedModel
  extend Serket::DecryptedFields
  extend Serket::EncryptedFields

  attr_accessor :name, :email

  decrypted_fields :name
  encrypted_fields :email

  def write_attribute(field, value)
    self.instance_variable_set("@#{field}", value)
  end
end

require_relative "./serket/version"
require_relative "./serket/field_decrypter.rb"
require_relative "./serket/field_encrypter.rb"
require_relative "./serket/decrypted_fields.rb"
require_relative "./serket/encrypted_fields.rb"
require_relative "./serket/configuration.rb"

module Serket
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
  
  def self.encrypt(text)
    FieldEncrypter.new.encrypt(text)
  end

  def self.decrypt(cipher)
    FieldDecrypter.new.decrypt(cipher)
  end
end

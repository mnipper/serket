require 'openssl'
require 'base64'

module Serket
  # Used to decrypt a field given a private key, field delimiter, symmetric
  # algorithm, encoding, and format (:json or :delimited)
  class FieldDecrypter
    attr_accessor :field_delimiter, :private_key_filepath, :symmetric_algorithm, :encoding

    def initialize(options = {})
      options ||= {}

      @private_key_filepath   = Serket.configuration.private_key_path
      @field_delimiter        = options[:field_delimiter]     || Serket.configuration.delimiter 
      @symmetric_algorithm    = options[:symmetric_algorithm] || Serket.configuration.symmetric_algorithm
      @format                 = options[:format]              || Serket.configuration.format
      @encoding               = options[:encoding]            || Serket.configuration.encoding
    end

    # Decrypt the provided cipher text, and return the plaintext
    # Return nil if whitespace
    def decrypt(field)
      return if field !~ /\S/
      iv, encrypted_aes_key, encrypted_text = parse(field)
      private_key = OpenSSL::PKey::RSA.new(File.read(private_key_filepath))
      decrypted_aes_key = private_key.private_decrypt(Base64.decode64(encrypted_aes_key))
      decrypted_field = decrypt_data(iv, decrypted_aes_key, encrypted_text)
      decrypted_field.force_encoding(encoding)
    end

    # What delimiter to use if the format is :delimited.
    #
    # Allow anything that is not base64.
    def field_delimiter=(delimiter)
      if delimiter =~ /[A-Za-z0-9\/+]/
        raise "This is not a valid delimiter!  Must not be a character in Base64."
      end

      @field_delimiter = delimiter
    end

    private
      def decrypt_data(iv, key, encrypted_text)
        aes = OpenSSL::Cipher.new(symmetric_algorithm)
        aes.decrypt
        aes.key = key
        aes.iv = Base64.decode64(iv)
        aes.update(Base64.decode64(encrypted_text)) + aes.final
      end

      # Extracts the initialization vector, encrypted key, and
      # cipher text according to the specified format.
      #
      # delimited:
      # * Expected format: iv::encrypted-key::ciphertext
      #
      # json:
      # * Expected keys: iv, key, message
      def parse(field)
        case @format
        when :delimited
          field.split(field_delimiter)
        when :json
          parsed = JSON.parse(field)
          [parsed['iv'], parsed['key'], parsed['message']]
        end
      end
  end
end

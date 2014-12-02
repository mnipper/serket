require 'openssl'
require 'base64'

module Serket
  class FieldDecrypter
    attr_accessor :field_delimiter, :private_key_filepath, :symmetric_algorithm

    def initialize(options = {})
      options ||= {}

      @private_key_filepath   = Serket.configuration.private_key_path
      @field_delimiter        = options[:field_delimiter]     || Serket.configuration.delimiter 
      @symmetric_algorithm    = options[:symmetric_algorithm] || Serket.configuration.symmetric_algorithm
      @format                 = options[:format]              || Serket.configuration.format
    end

    def decrypt(field)
      return if field !~ /\S/
      iv, encrypted_aes_key, encrypted_text = parse(field)
      private_key = OpenSSL::PKey::RSA.new(File.read(private_key_filepath))
      decrypted_aes_key = private_key.private_decrypt(Base64.decode64(encrypted_aes_key))
      decrypt_data(iv, decrypted_aes_key, encrypted_text)
    end

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

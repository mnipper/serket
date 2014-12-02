module Serket
  # Controls various configuration options such as key locations, desired
  # algorithms and expected cipher text format.
  #
  # * +private_key_path+ - The filepath to a RSA private key
  # * +public_key_path+ - The filepath to a RSA public key
  # * +delimiter+ - If the format is set to :delimited, use this delimiter.
  #                 Must not be a character in base64.
  # * +format+ - May be :delimited or :json
  # * +symmetric_algorithm+ - May be any algorithm that may be used with OpenSSL::Cipher
  #
  class Configuration
    attr_accessor :private_key_path, :public_key_path, :delimiter, :format, :symmetric_algorithm

    def initialize
      @delimiter = "::"
      @format = :delimited
      @symmetric_algorithm = 'AES-256-CBC'
    end
  end
end

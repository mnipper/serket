module Serket
  class Configuration
    attr_accessor :private_key_path, :public_key_path, :delimiter, :format, :symmetric_algorithm

    def initialize
      @delimiter = "::"
      @format = :delimited
      @symmetric_algorithm = 'AES-256-CBC'
    end
  end
end

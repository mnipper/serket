require "rspec"
require "json"

$:.unshift((Pathname(__FILE__).dirname.parent + "lib").to_s)

require "serket"

Serket.configure do |config|
  config.private_key_path = "spec/resources/test_private_key.pem"
  config.public_key_path = "spec/resources/test_public_key.pem"
end

require "serket/models/encrypted_model.rb"

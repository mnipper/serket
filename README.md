# Serket

A gem for creating encrypted data using RSA and (by default) AES-256-CBC.

The envisioned use case for this is to encrypt data before saving it to a server or mobile device using a public key, and decrypting that data only when it is sent to another server that has the private key.

## Installation

Add this line to your application's Gemfile:

    gem 'serket'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install serket

## Usage

### Encrypting data

To encrypt data, you must first tell serket where your public key is:

```
Serket.configure do |config|
  config.public_key_path = "path/to/public_key.pem"
end
```

You can then use the FieldEncrypter class to encrypt some text:
``
  Serket::FieldEncrypter.new.encrypt("Hello out there!")
``

By default, this will return a double-colon (::) delimited string.  The first field is the initialization vector used for the symmetric encryption algorithm (by default, this is AES-256-CBC).  The second field is the encrypted key for the symmetric algorithm.  This key is encrypted using RSA, using the provided public key.  The final field is the encrypted text ("Hello out there!" in this example).


### Decrypting data

To decrypt data, tell serket where to find your private key:
```
Serket.configure do |config|
  config.private_key_path = "path/to/private_key.pem"
end
```

This expects the same format described for encryption, and is the inverse operation.

```
  Serket::FieldDecrypter.new.decrypt(encrypted_from_before)
```

### Quick Start

```
Serket.configure do |config|
  config.public_key_path = "public_key.pem"
  config.private_key_path = "private_key.pem"
end

encrypted = Serket::FieldEncrypter.new.encrypt("Hello out there!")
puts "#{encrypted} can be decrypted to #{Serket::FieldDecrypter.new.decrypt(encrypted)}"
```

### Additional configuration

There are a few more configuration options.

| Config                   | Default       | Options                               |
| ------------------------ |---------------| --------------------------------------|
| format                   | :delimited    | :delimited, :json                     |
| symmetric_algorithm      | AES-256-CBC   | Any valid cipher from OpenSSL::Cipher |
| delimiter                | ::            | Anything not base64                   |

These can all be modified in the configuration block, eg:

```
Serket.configure do |config|
  config.format = :json
end


Serket.configure do |config|
  config.delimiter = '**'
end
```

Note: trying to use a delimiter in the base64 character set throws an exception.  This is because the iv/encrypted key/encrypted text are encoded in base64, and so it is a bad idea to use something in base64 as a delimiter.

### Use with Rails

There are also some helpers if you are using rails that make encryption/decryption straight forward.  Assuming you have a model with a name field that you would like to encrypt before saving to the database, you could do so like this:

```
class EncryptedModel < ActiveRecord::Base
  extend Serket::EncryptedFields

  encrypted_fields :name
end
```

If you instead would like to decrypt a field before saving (for example, and encrypted value that is coming from an api), then you could do so like this:

```
class DecryptedModel < ActiveRecord::Base
  extend Serket::DecryptedFields

  decrypted_fields :name
end
```

This will automatically decrypt any values before saving assuming it matches your configurations.

I recommend putting an initializer at config/initializers/serket.rb and putting your serket config block there.  I would also recommend having dummy keys for test/development, and using different config blocks depending on current env (test/development vs production). 
For example:
```
if Rails.env.production?
  Serket.configure do |config|
    config.public_key_path = "config/keys/public_key.pem"
    config.private_key_path = "config/keys/private_key.pem"
  end
else
  Serket.configure do |config|
    config.public_key_path = "config/keys/test_public_key.pem"
    config.private_key_path = "config/keys/test_private_key.pem"
  end
end
```

### Android Java Client

You can see an example java client for use with Android in EncryptUtil.java

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

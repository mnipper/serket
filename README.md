# Serket

A gem for creating encrypted data using RSA and (by default) AES-256-CBC.

The envisioned use case for this is to encrypt data before saving it to a server or mobile device using a public key, and decrypting that data only when it is sent to another server that has the private key.

It works by generating a random AES key, encrypting text with that generated key, encrypting the generated AES key with RSA, and then saving the initialization vector + rsa-encrypted aes-key + the aes-encrypted cipher text in either a delimited string or json.

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

You can then encrypt some text:
``
  Serket.encrypt("Hello out there!")
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
  Serket.decrypt(Serket.encrypt('Hello out there!'))
```

### Quick Start

```
Serket.configure do |config|
  config.public_key_path = "public_key.pem"
  config.private_key_path = "private_key.pem"
end

encrypted = Serket.encrypt("Hello out there!")
puts "#{encrypted} can be decrypted to #{Serket.decrypt(encrypted)}"
```

### Additional configuration

There are a few more configuration options.

| Config                   | Default       | Options                               |
| ------------------------ |---------------| --------------------------------------|
| format                   | :delimited    | :delimited, :json                     |
| symmetric_algorithm      | AES-256-CBC   | Any valid cipher from OpenSSL::Cipher |
| delimiter                | ::            | Anything not base64                   |
| encoding                 | utf-8         | Any valid ruby encoding               |

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

If you instead would like to decrypt a field before saving (for example, an encrypted value that is coming from an api), then you could do so like this:

```
class DecryptedModel < ActiveRecord::Base
  extend Serket::DecryptedFields

  decrypted_fields :name
end
```

This will automatically decrypt any values before saving assuming it matches your configurations.

I recommend putting an initializer at config/initializers/serket.rb and putting your serket config block there.

For example:
```
Serket.configure do |config|
  config.public_key_path = ENV["SERKET_PUBLIC_KEY"]
  config.private_key_path = ENV["SERKET_PRIVATE_KEY"]
end
```

You can do a sanity-check with your api endpoint by sending a post request for a model with decrypted_fields:
```
curl -v -H "Accept: application/json" -H "Content-type: application/json" -X POST -d '{"decrypted_model": {"name": "bm5gkjwdfv6QBUqFPEnOaw==::CtQJyXdbuLeVzmIOIr0h/F9yh7xvz5KWUgxe/u4IkORGOW4KjU4bw+Wzve2vV1nLYUEWJJprr8sb+grm+Ao2sngNejiHzSkJKqZA/Pclw/Ok8KgHgN7olUz4BoCSdivIDRIT9ar06sNBrqOvLd4iGUlpMkpLdSJ69K08ebSvg5tED+PcK/oI6SJoVxRoUMYdYa9AfeIS9Ld5BgvhsaJgCKr089kfH2CzwpzlmRfdxb2qgyDXnk9PG/4WUEjjbamF/R74FNBdWkTLxZeLGdMImh87CQ6AOJ/v8l1JSzpPWwEjtmhTbFEzJPuA01tP5U5D07si0esJnab/B48iACEoLg==::iSmdDgnTzkEUv0yLbtFa8Q=="}}' http://localhost:3000/api/v1/decrypted_models
```

This should automatically decrypt the name for the decrypted_model before saving if you use the provided private key located in spec/resources/test_private_key.pem (and keep the default configs for delimited with ::)

**Just be sure to use your own keys in production!**

### Android Java Client

You can see an example java client for use with Android in EncryptUtil.java

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

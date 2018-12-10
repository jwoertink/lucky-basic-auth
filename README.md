# lucky-basic-auth

Adds some basic auth in to your lucky app using a pipe instead of HTTP Handler

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  lucky-basic-auth:
    github: jwoertink/lucky-basic-auth
```
2. Run `shards install`

## Usage

```crystal
# in src/dependencies.cr
require "lucky-basic-auth"
```

```crystal
# in src/actions/browser_action.cr
abstract class BrowserAction < Lucky::Action
  include Lucky::ProtectFromForgery
  include Lucky::BasicAuthPipe

  #...
end
```

```crystal
# in src/actions/whatever/your_action.cr
class Whatever::YourAction < BrowserAction
  before authenticate_login

  #...
end
```


## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/jwoertink/lucky-basic-auth/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jeremy Woertink](https://github.com/jwoertink) - creator and maintainer

# lucky-basic-auth

Adds some basic auth in to your lucky app using a pipe instead of HTTP Handler

## Installation

Requires Lucky v0.17 or later

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  lucky-basic-auth:
    github: jwoertink/lucky-basic-auth
```
2. Run `shards install`

## Usage

Require the shard
```crystal
# in src/shards.cr
require "lucky-basic-auth"
```

Include it in your main BrowserAction
```crystal
# in src/actions/browser_action.cr
abstract class BrowserAction < Lucky::Action
  include Lucky::ProtectFromForgery

  # include it
  include Lucky::BasicAuthPipe

  # use it
  basic_auth
end
```

Or, you can also make a subclass to handle auths
```crystal
# src/actions/authorized_action.cr
abstract class AuthorizedAction < BrowserAction
  include Lucky::BasicAuthPipe

  basic_auth
end

class MyAction < AuthorizedAction
  get "/admin/my_action" do
    plain_text "I'm secure!"
  end
end
```

Call the `basic_auth` to enable.
```crystal
# in src/actions/whatever/your_action.cr
class Whatever::YourAction < BrowserAction
  basic_auth

  #...
end
```

This method requires 2 `ENV` variables to exist. This will check for the username and password to match these variables.

```crystal
ENV["AUTH_USERNAME"]
ENV["AUTH_PASSWORD"]
```

If you need more control over how the values are checked (e.g. lookup from a database, or check role authorization), you can pass a proc.


```crystal
# in src/actions/whatever/your_action.cr
class Whatever::YourAction < BrowserAction
  basic_auth ->(user, pass) {
    user == MY_USERNAME_THING && pass == MY_PASSWORD_CHECKER
  }

  #...
end
```

This gives you the option to set different user and pass per action if you want.


## Development

write specs

## Contributing

1. Fork it (<https://github.com/jwoertink/lucky-basic-auth/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Jeremy Woertink](https://github.com/jwoertink) - creator and maintainer

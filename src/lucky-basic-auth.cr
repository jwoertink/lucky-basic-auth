require "base64"
require "crypto/subtle"

module Lucky::BasicAuthPipe
  VERSION               = "0.2.0"
  BASIC                 = "Basic"
  AUTH                  = "Authorization"
  AUTH_MESSAGE          = "Could not verify your access level.\nYou must login to continue"
  HEADER_LOGIN_REQUIRED = %{Basic realm="Login Required"}

  macro basic_auth
    def authorize
      show_login = true
      if value = @context.request.headers[AUTH]?
        if value.size > 0 && value.starts_with?(BASIC)
          username, password = Base64.decode_string(value[BASIC.size + 1..-1]).split(":")
          if compare_values(username, ENV["AUTH_USERNAME"]) && compare_values(password, ENV["AUTH_PASSWORD"])
            show_login = false
          end
        end
      end

      if show_login
        @context.response.headers["WWW-Authenticate"] = HEADER_LOGIN_REQUIRED
        plain_text AUTH_MESSAGE, status: 401
      else
        continue
      end
    end

    before authorize
  end

  macro basic_auth(block)
    def authorize
      show_login = true
      if value = @context.request.headers[AUTH]?
        if value.size > 0 && value.starts_with?(BASIC)
          {{block.args[0]}}, {{block.args[1]}} = Base64.decode_string(value[BASIC.size + 1..-1]).split(":")
          if {{block.body}}
            show_login = false
          end
        end
      end

      if show_login
        @context.response.headers["WWW-Authenticate"] = HEADER_LOGIN_REQUIRED
        plain_text AUTH_MESSAGE, status: 401
      else
        continue
      end
    end

    before authorize
  end

  @[AlwaysInline]
  private def compare_values(given_value : String, expected_value : String)
    Crypto::Subtle.constant_time_compare(given_value, expected_value)
  end
end

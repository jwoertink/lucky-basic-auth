require "base64"

module Lucky::BasicAuthPipe
  VERSION               = "0.1.0"
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
          if username == ENV["AUTH_USERNAME"] && ENV["AUTH_PASSWORD"]
            show_login = false
          end
        end
      end

      if show_login
        headers = HTTP::Headers.new
        @context.response.status_code = 401
        @context.response.headers["WWW-Authenticate"] = HEADER_LOGIN_REQUIRED
        text AUTH_MESSAGE
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
        headers = HTTP::Headers.new
        @context.response.status_code = 401
        @context.response.headers["WWW-Authenticate"] = HEADER_LOGIN_REQUIRED
        text AUTH_MESSAGE
      else
        continue
      end
    end

    before authorize
  end
end

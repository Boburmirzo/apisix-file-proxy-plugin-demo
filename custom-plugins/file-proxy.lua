-- Introduce the module we need in the header
local core     = require("apisix.core")
local io       = require("io")
local ngx      = ngx

-- Declare the plugin's name
local plugin_name = "file-proxy"

-- Define the plugin schema format
local plugin_schema = {
    type = "object",
    properties = {
        path = {
            type = "string"
        },
    },
    required = {"path"}
}

local _M = {
    version = 0.1,
    priority = 1000,
    name = plugin_name,
    schema = plugin_schema
}

-- Check if the plugin configuration is correct
function _M.check_schema(conf)
  local ok, err = core.schema.check(plugin_schema, conf)
  if not ok then
      return false, err
  end

  return true
end

function _M.access(conf, ctx)
  local fd = io.open(conf.path, "rb")
  if fd then
    local content = fd:read("*all")
    fd:close()
    ngx.header.content_length = #content
    ngx.say(content)
    ngx.exit(ngx.OK)
  else
    ngx.exit(ngx.HTTP_NOT_FOUND)
    core.log.error("File is not found: ", conf.path, ", error info: ", err)
  end
end


-- Log phase
function _M.log(conf, ctx)
    core.log.warn("conf: ", core.json.encode(conf))
    core.log.warn("ctx: ", core.json.encode(ctx, true))
end

return _M
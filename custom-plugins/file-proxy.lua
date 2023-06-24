-- Introduce the necessary modules/libraries we need for this plugin 
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
            type = "string" -- The path of the file to be served
        },
    },
    required = {"path"} -- The path is a required field
}

-- Define the plugin with its version, priority, name, and schema
local _M = {
    version = 1.0,
    priority = 1000,
    name = plugin_name,
    schema = plugin_schema
}

-- Function to check if the plugin configuration is correct
function _M.check_schema(conf)
  -- Validate the configuration against the schema
  local ok, err = core.schema.check(plugin_schema, conf)
  -- If validation fails, return false and the error
  if not ok then
      return false, err
  end
  -- If validation succeeds, return true
  return true
end

-- Function to be called during the access phase
function _M.access(conf, ctx)
  -- Open the file specified in the configuration
  local fd = io.open(conf.path, "rb")
  -- If the file is opened successfully, read its content and return it as the response
  if fd then
    local content = fd:read("*all")
    fd:close()
    ngx.header.content_length = #content
    ngx.say(content)
    ngx.exit(ngx.OK)
  else
    -- If the file cannot be opened, log an error and return a 404 Not Found status
    ngx.exit(ngx.HTTP_NOT_FOUND)
    core.log.error("File is not found: ", conf.path, ", error info: ", err)
  end
end


-- Function to be called during the log phase
function _M.log(conf, ctx)
    -- Log the plugin configuration and the request context
    core.log.warn("conf: ", core.json.encode(conf))
    core.log.warn("ctx: ", core.json.encode(ctx, true))
end

-- Return the plugin so it can be used by APISIX
return _M
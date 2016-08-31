local root = "../"
package.cpath = root .. "skynet/luaclib/?.so"
package.path  = root .. "common/?.lua;" .. root .."skynet/lualib/?.lua;" .. root .."global/?.lua"

require "utils"
local uuid = require "uuid"

local gameid,instid = string.match("login1.login", "(%w+)(%.%w+)")




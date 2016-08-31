local skynet = require "skynet"
local debugPort = skynet.getenv("debugPort")

skynet.start(function ()
	local console = skynet.newservice("console", debugPort)
	local log     = skynet.uniqueservice("serverlog")
	local prototest = skynet.newservice("prototest")

	print("test server start")
end)

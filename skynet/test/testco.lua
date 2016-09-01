local skynet = require "skynet"
local coroutine = require "skynet.coroutine"
local queue = require "skynet.queue"
local list = {}
local i = 0
local consumer

local cs = queue()

local __randomseed = os.time()
function math.rand(...)
    __randomseed = __randomseed + 1
    math.randomseed(__randomseed)
    return math.random(...)
end

local function add_work()
	local count = math.rand(5)
	for k=1, count do
		i = i + 1
		local work = "work "..i
		print("recv "..work)
		cs(function()
			table.insert(list, work)
		end)
	end
	coroutine.resume(consumer)
	
	skynet.timeout(2*100, add_work)
end

skynet.start(function()
	consumer = coroutine.create(function()
		while true do
			cs(function()
				for k, work in pairs(list) do
					print("deal "..work)
					list[k] = nil
				end
			end)
			coroutine.yield()
		end
	end)
	skynet.timeout(1*100, add_work)
end)

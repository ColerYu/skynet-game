local skynet = require "skynet"
local redis = require "redis"

local conf = {
	host = "127.0.0.1" ,
	port = 6379 ,
	db = 0
}

local function watching()
	local w = redis.watch(conf)
	w:subscribe "foo"
	w:psubscribe "hello.*"
	while true do
		print("Watch", w:message())
	end
end

function tableToString(root)
    if root == nil then
        return "nil"
    end
    local cache = {  [root] = "." }
    local function _dump(t,space,name)
        local temp = {}
        for k,v in pairs(t) do
            local key = tostring(k)
            if cache[v] then
                table.insert(temp,"+" .. key .. " {" .. cache[v].."}")
            elseif type(v) == "table" then
                local new_key = name .. "." .. key
                cache[v] = new_key
                table.insert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. string.rep(" ",#key),new_key))
            else
                table.insert(temp,"+" .. key .. " [" .. tostring(v).."]")
            end
        end
        return table.concat(temp,"\n"..space)
    end
    return (_dump(root, "",""))
end

skynet.start(function()
	skynet.fork(watching)
	local db = redis.connect(conf)

	print(tableToString(db:hgetall("tb_account:kuzhu1990")))

	-- db:del "C"
	-- db:set("A", "hello")
	-- db:set("B", "world")
	-- db:sadd("C", "one")

	-- print(db:get("A"))
	-- print(db:get("B"))

	-- db:del "D"
	-- for i=1,10 do
	-- 	db:hset("D",i,i)
	-- end
	-- local r = db:hvals "D"
	-- for k,v in pairs(r) do
	-- 	print(k,v)
	-- end

	-- db:multi()
	-- db:get "A"
	-- db:get "B"
	-- local t = db:exec()
	-- for k,v in ipairs(t) do
	-- 	print("Exec", v)
	-- end

	-- print(db:exists "A")
	-- print(db:get "A")
	-- print(db:set("A","hello world"))
	-- print(db:get("A"))
	-- print(db:sismember("C","one"))
	-- print(db:sismember("C","two"))

	-- print("===========publish============")

	-- for i=1,10 do
	-- 	db:publish("foo", i)
	-- end
	-- for i=11,20 do
	-- 	db:publish("hello.foo", i)
	-- end

	db:disconnect()
--	skynet.exit()
end)


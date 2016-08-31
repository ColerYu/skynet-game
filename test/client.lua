local root = "../"
package.cpath = root .. "skynet/luaclib/?.so"
package.path  = root .. "common/?.lua;" .. root .."skynet/lualib/?.lua;" .. root .."global/?.lua"

local crypt = require "crypt"
local socket = require "clientsocket"
local protobuf = require "protobuf"
local protomap = require "protomap"
require "utils"

local protofile = {
	"login.pb",
	"lobby.pb",
	"game.pb",
	"role.pb",
	"dzz.pb",
}

local function register_protos()
	local pbpath = root .. "pb/"
	for _, file in ipairs(protofile) do
		protobuf.register_file(pbpath .. file)
	end
end

register_protos()

local session = 0
local last = ""
local fd = assert(socket.connect("127.0.0.1", 4001))

local function alloc_buffer(size)
	local buffer = ""
	for i=1, size do
		buffer = buffer .. "0"
	end
	return buffer
end

local function send_package(pack)
	local packBuf = string.pack(">s2", pack)
	socket.send(fd, packBuf)
	--print("send_package fd:", fd)
end

local function unpack_package(text)
	local size = #text
	--print("unpack_package size:", size)
	if size < 2  then
		return nil, text
	end
	local s = text:byte(1) * 256 + text:byte(2)
	if size < s+2 then
		return nil, text
	end
	return text:sub(3, 2+s), text:sub(3+s)
end

local function recv_package(last)
	local result
	result, last = unpack_package(last)
	if result then
		return result, last
	end
	local buf = socket.recv(fd)
	if not buf then
		return nil, last
	end
	if buf == "" then
		error "server closed"
	end
	return unpack_package(last..buf)
end

--[[==================================================]]
--[[
	@method请求的方法名如"login.login"
	@args 请求的参数
]]
local function send_request(method, data)
	session = session+1
	local methodId = protomap.methods[method]
	local proto = protomap.protos[methodId]
	local buffer = protobuf.encode(proto.request, data)
	--buffer = alloc_buffer(4) .. buffer
	--protobuf.encode_int16(buffer, 0, methodId)
	--protobuf.encode_int16(buffer, 2, session)
	buffer = string.pack(">I2", methodId)..string.pack(">I2", session)..buffer
	buffer = crypt.xor_data(buffer, #buffer)
	send_package(buffer)
end

local function dispatch_package()
	while true do
		local v
		v, last = recv_package(last)
		if not v then
			break
		end
		--local methodId   = protobuf.decode_int16(v, 0)
		--local requestId  = protobuf.decode_int16(v, 2)
		--local errcode    = protobuf.decode_int16(v, 4)
		v = crypt.xor_data(v, #v)
		local methodId, requestId, errcode = string.unpack(">hhh",v)
		local proto = protomap.protos[methodId]
		local reply = protobuf.decode_ex(proto.response, v, 6)
		--打印收到的回包
		print("dispatch_package methodId:", methodId, "requestId:", requestId, "errcode:", errcode, "reply:", tableToString(reply))
	end
end


local function check_cmd(s)
    if s == "" or s == nil then
        return s
    end

    local cmd = ""
    local args = nil
    local b, e = string.find(s, " ")
    if b then
        cmd = s:sub(0, b - 1)
        local args_data = "return " .. s:sub(e + 1)
        local f, err = load(args_data)
        if f == nil then
            print("illegal cmd", s, _args)
            return
        end

        local ok, _args = pcall(f)
        if (not ok) or (type(_args) ~= 'table') then
            print("illegal cmd", s, _args)
            return
        else
            args = _args
        end
    else
        cmd = s
    end

    local args = args or default_args[cmd]
    local ok, err = pcall(send_request, cmd, args)
    if not ok then
        print('send err', cmd, args, err)
    end
end

local function main()
	--[[local req = {}
	req.base = {
		clientType = 1,
		ip = "127.0.0.1",
		hardwareNo = "1234-ef-2234",
		version = "2.0.1",
	}
	req.username = "kuzhu1990"
	req.password = "005318"
	send_request("login.login", req)
	]]

	while true do
		check_cmd(socket.readstdin())
		dispatch_package()
		socket.usleep(1000000)
	end
	print("quit")
end

main()

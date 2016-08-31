local errors = {}

function errmsg(ec)
	return errors[ec]
end

local function add(err)
	assert(errors[err.code] == nil, string.format("have the same error code[%x], msg[%s]", err.code, err.message))
	errors[err.code] = err.message
	return err.code
end

SystemError = {
	success            = add{code = 0x0000, message = "成功"},
	forward            = add{code = 0x0001, message = "重定向"},
	unknown            = add{code = 0x0002, message = "未知错误"},
	timeout            = add{code = 0x0003, message = "请求超时"},
	serialize          = add{code = 0x0004, message = "序列化错误"},
	argument           = add{code = 0x0005, message = "参数错误"},
	service_closed     = add{code = 0x0006, message = "服务已经关闭"},
	service_not_open   = add{code = 0x0007, message = "服务没有开放"},
	not_implement      = add{code = 0x0008, message = "协议未实现"},
	illegal_operation  = add{code = 0x0009, message = "非法操作"},
	db                 = add{code = 0x000a, message = "数据库操作失败"},
	message_too_long   = add{code = 0x000b, message = "消息包太长"},
	proto_not_exists   = add{code = 0x000c, message = "不存在此协议"},
	busy               = add{code = 0x000d, message = "服务繁忙"},
	network            = add{code = 0x000e, message = "网络异常"},
	service_mantenance = add{code = 0x000f, message = "服务器维护"},
}

LoginError = {
	has_logined       = add{code = 0x0101, message = "已经登录该帐号"},
	other_logining    = add{code = 0x0102, message = "您正在其它地方登录"},
	auth_failed       = add{code = 0x0103, message = "验证密码失败"},
	other_register    = add{code = 0x0104, message = "其它地方正在注册"},
}

LobbyError = {
	session_invalid   = add{code = 0x0201, message = "会话已经失效"},
	not_logined       = add{code = 0x0202, message = "玩家未登录"},
}

DzzError = {
	player_not_indesk = add{code = 0x0301, message = "玩家未加入游戏台"},
}

return errors
--[[一般节点服务都是确定的只是实际节点地址端口有可能改变]]
center = {
	nodeaddr = "127.0.0.1:5000", 
	nodetype = "center",
	services = {".nodemgr"},
	open    = true,
}
gate1 = {
	nodeaddr = "127.0.0.1:6000", 
	nodetype = "gate",
	services = {".watchdog"},
	open    = true,
}
login1 = {
	nodeaddr = "127.0.01:7000", 
	nodetype = "login",
	services = {".login"},
	open    = true,
}
lobby = {
	nodeaddr = "127.0.01:8000", 
	nodetype = "lobby",
	services = {".lobby"},
	open    = true,
}
by = {
	nodeaddr = "127.0.01:9001", 
	nodetype = "game",
	services = {".agent_mgr"},
	open    = true,
}

dzz = {
	nodeaddr = "127.0.01:9000", 
	nodetype = "game",
	services = {".agent_mgr"},
	open    = true,
}

nn = {
	nodeaddr = "127.0.01:9000", 
	nodetype = "game",
	services = {".agent_mgr"},
	open    = true,
}

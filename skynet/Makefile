include platform.mk

LUA_CLIB_PATH ?= luaclib
CSERVICE_PATH ?= cservice

SKYNET_BUILD_PATH ?= .

BUILD_LUALIB_DIR ?= lualib

CFLAGS = -g -O2 -Wall -I$(LUA_INC) $(MYCFLAGS)
# CFLAGS += -DUSE_PTHREAD_LOCK

# lua

LUA_STATICLIB := 3rd/lua/liblua.a
LUA_LIB ?= $(LUA_STATICLIB)
LUA_INC ?= 3rd/lua

$(LUA_STATICLIB) :
	cd 3rd/lua && $(MAKE) CC='$(CC) -std=gnu99' $(PLAT)

# jemalloc 

JEMALLOC_STATICLIB := 3rd/jemalloc/lib/libjemalloc_pic.a
JEMALLOC_INC := 3rd/jemalloc/include/jemalloc

all : jemalloc zlib
	
.PHONY : jemalloc

MALLOC_STATICLIB := $(JEMALLOC_STATICLIB)

$(JEMALLOC_STATICLIB) : 3rd/jemalloc/Makefile
	cd 3rd/jemalloc && $(MAKE) CC=$(CC) 

3rd/jemalloc/autogen.sh :
	git submodule update --init

3rd/jemalloc/Makefile : | 3rd/jemalloc/autogen.sh
	cd 3rd/jemalloc && ./autogen.sh --with-jemalloc-prefix=je_ --disable-valgrind

jemalloc : $(MALLOC_STATICLIB)


#Penlight
Penlight:
	cp -r 3rd/Penlight/lua/pl $(BUILD_LUALIB_DIR)

#argparse
argparse:
	cp 3rd/argparse/src/argparse.lua $(BUILD_LUALIB_DIR)/

#lua-orm
lua-orm:
	cp 3rd/lua-orm/orm.lua 3rd/lua-orm/typedef.lua $(BUILD_LUALIB_DIR)/

#zlib
ZLIB_STATICLIB := 3rd/lua-zlib/src/libz.a
Z_LIB ?= $(ZLIB_STATICLIB)

$(ZLIB_STATICLIB) :
	cd 3rd/lua-zlib/src && sh ./configure --libdir=./ && $(MAKE)
zlib : $(ZLIB_STATICLIB)

# skynet

CSERVICE = snlua logger gate harbor
LUA_CLIB = skynet socketdriver bson mongo md5 netpack \
  clientsocket memory profile multicast \
  cluster crypt sharedata stm sproto lpeg \
  mysqlaux debugchannel protobuf zlib cjson \
  lsocket ctime lfs lcrab levent
NEW_CSERVICE = libcrab

SKYNET_SRC = skynet_main.c skynet_handle.c skynet_module.c skynet_mq.c \
  skynet_server.c skynet_start.c skynet_timer.c skynet_error.c \
  skynet_harbor.c skynet_env.c skynet_monitor.c skynet_socket.c socket_server.c \
  malloc_hook.c skynet_daemon.c skynet_log.c

all : \
  $(SKYNET_BUILD_PATH)/skynet \
  $(foreach v, $(CSERVICE), $(CSERVICE_PATH)/$(v).so) \
  $(foreach v, $(NEW_CSERVICE), $(CSERVICE_PATH)/$(v).so) \
  $(foreach v, $(LUA_CLIB), $(LUA_CLIB_PATH)/$(v).so) 


$(SKYNET_BUILD_PATH)/skynet : $(foreach v, $(SKYNET_SRC), skynet-src/$(v)) $(LUA_LIB) $(MALLOC_STATICLIB)
	$(CC) $(CFLAGS) -o $@ $^ -Iskynet-src -I$(JEMALLOC_INC) $(LDFLAGS) $(EXPORT) $(SKYNET_LIBS) $(SKYNET_DEFINES)

$(LUA_CLIB_PATH) :
	mkdir $(LUA_CLIB_PATH)

$(CSERVICE_PATH) :
	mkdir $(CSERVICE_PATH)

define CSERVICE_TEMP
  $$(CSERVICE_PATH)/$(1).so : service-src/service_$(1).c | $$(CSERVICE_PATH)
	$$(CC) $$(CFLAGS) $$(SHARED) $$< -o $$@ -Iskynet-src
endef

$(foreach v, $(CSERVICE), $(eval $(call CSERVICE_TEMP,$(v))))

$(LUA_CLIB_PATH)/skynet.so: lualib-src/lua-skynet.c lualib-src/lua-seri.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@ -Iskynet-src -Iservice-src -Ilualib-src

$(LUA_CLIB_PATH)/socketdriver.so: lualib-src/lua-socket.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@ -Iskynet-src -Iservice-src

$(LUA_CLIB_PATH)/bson.so: lualib-src/lua-bson.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -Iskynet-src $^ -o $@ -Iskynet-src

$(LUA_CLIB_PATH)/mongo.so: lualib-src/lua-mongo.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@ -Iskynet-src

$(LUA_CLIB_PATH)/md5.so: 3rd/lua-md5/md5.c 3rd/lua-md5/md5lib.c 3rd/lua-md5/compat-5.2.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -I3rd/lua-md5 $^ -o $@ 

$(LUA_CLIB_PATH)/netpack.so: lualib-src/lua-netpack.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -Iskynet-src -o $@ 

$(LUA_CLIB_PATH)/clientsocket.so: lualib-src/lua-clientsocket.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@ -lpthread

$(LUA_CLIB_PATH)/memory.so: lualib-src/lua-memory.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -Iskynet-src $^ -o $@ 

$(LUA_CLIB_PATH)/profile.so: lualib-src/lua-profile.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@ 

$(LUA_CLIB_PATH)/multicast.so: lualib-src/lua-multicast.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -Iskynet-src $^ -o $@ 

$(LUA_CLIB_PATH)/cluster.so: lualib-src/lua-cluster.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -Iskynet-src $^ -o $@ 

$(LUA_CLIB_PATH)/crypt.so: lualib-src/lua-crypt.c lualib-src/lsha1.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@ 

$(LUA_CLIB_PATH)/sharedata.so: lualib-src/lua-sharedata.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -Iskynet-src $^ -o $@ 

$(LUA_CLIB_PATH)/stm.so: lualib-src/lua-stm.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -Iskynet-src $^ -o $@ 

$(LUA_CLIB_PATH)/sproto.so: lualib-src/sproto/sproto.c lualib-src/sproto/lsproto.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -Ilualib-src/sproto $^ -o $@ 

$(LUA_CLIB_PATH)/lpeg.so: 3rd/lpeg/lpcap.c 3rd/lpeg/lpcode.c 3rd/lpeg/lpprint.c 3rd/lpeg/lptree.c 3rd/lpeg/lpvm.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -I3rd/lpeg $^ -o $@ 

$(LUA_CLIB_PATH)/mysqlaux.so: lualib-src/lua-mysqlaux.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@	

$(LUA_CLIB_PATH)/debugchannel.so: lualib-src/lua-debugchannel.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -Iskynet-src $^ -o $@	

#cjson
$(LUA_CLIB_PATH)/cjson.so: | $(LUA_CLIB_PATH)
	cd 3rd/lua-cjson && $(MAKE) LUA_INCLUDE_DIR=../../$(LUA_INC) CC=$(CC) \
	CJSON_LDFLAGS="$(SHARED)" && cd ../.. && cp 3rd/lua-cjson/cjson.so $@

#zlib
$(LUA_CLIB_PATH)/zlib.so: 3rd/lua-zlib/lua_zlib.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -I3rd/lua-zlib -L3rd/lua-zlib/src $^ -o $@ -lz

#protobuf
$(LUA_CLIB_PATH)/protobuf.so:  3rd/lua-pbc/alloc.c 3rd/lua-pbc/array.c 3rd/lua-pbc/bootstrap.c \
	3rd/lua-pbc/context.c 3rd/lua-pbc/decode.c 3rd/lua-pbc/map.c 3rd/lua-pbc/pattern.c 3rd/lua-pbc/proto.c \
	3rd/lua-pbc/register.c 3rd/lua-pbc/rmessage.c 3rd/lua-pbc/stringpool.c 3rd/lua-pbc/varint.c \
	3rd/lua-pbc/wmessage.c 3rd/lua-pbc/pbc-lua.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -I3rd/lua-pbc $^ -o $@

#lsocket
$(LUA_CLIB_PATH)/lsocket.so: 3rd/lsocket/lsocket.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@

#libcrab.so
$(CSERVICE_PATH)/libcrab.so: 3rd/crab/crab.c
	$(CC) $(CFLAGS) $(SHARED) $^ -o $(CSERVICE_PATH)/libcrab.so

#lcrab.so
$(LUA_CLIB_PATH)/lcrab.so: 3rd/lua-crab/lua-crab.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) -I3rd/crab -L$(CSERVICE_PATH) $^ -o $@ $(LDFLAGS) -lcrab 

#log
#$(LUA_CLIB_PATH)/log.so: 3rd/lua-log/lua-log.c | $(LUA_CLIB_PATH)
#	$(CC) $(CFLAGS) $(SHARED) $^ -o $@

#ctime
$(LUA_CLIB_PATH)/ctime.so: 3rd/lua-ctime/lua-ctime.c | $(LUA_CLIB_PATH)
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@

#lfs
$(LUA_CLIB_PATH)/lfs.so: 3rd/luafilesystem/src/lfs.c | $(LUA_CLIB_PATH) 
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@

#zinc_client
$(CSERVICE_PATH)/zinc_client.so: 3rd/lua-zinc/zinc_client.c | $(CSERVICE_PATH) 
	$(CC) $(CFLAGS) $(SHARED) $^ -o $@

$(LUA_CLIB_PATH)/levent.so:
	cd 3rd/levent && sh cmake . && $(MAKE) && cp levent.so ../../$(LUA_CLIB_PATH) \
	 && cp -r levent ../../$(BUILD_LUALIB_DIR)


MKDIR= mkdir -p

BUILD = pb

$(BUILD) :
	$(MKDIR) $(BUILD)



clean :
	rm -f $(SKYNET_BUILD_PATH)/skynet $(CSERVICE_PATH)/*.so $(LUA_CLIB_PATH)/*.so

cleanall: clean
ifneq (,$(wildcard 3rd/jemalloc/Makefile))
	cd 3rd/jemalloc && $(MAKE) clean
endif
	cd 3rd/lua-cjson && $(MAKE) clean
	cd 3rd/lua && $(MAKE) clean
	cd 3rd/lua-zlib/src && $(MAKE) clean
	rm -f $(LUA_STATICLIB)


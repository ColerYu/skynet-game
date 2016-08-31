#!/bin/bash
branch=__default__
(./redis/redis-server ./redis/redis0.conf &)
(./redis/redis-server ./redis/redis1.conf &)
(./redis/redis-server ./redis/redis2.conf &)
(./redis/redis-server ./redis/redis3.conf &)
#(./redis/redis-server ./redis/redis4.conf &)
#(./redis/redis-server ./redis/redis5.conf &)
#(./redis/redis-server ./redis/redis6.conf &)
#(./redis/redis-server ./redis/redis7.conf &)
#(./redis/redis-server ./redis/redis8.conf &)
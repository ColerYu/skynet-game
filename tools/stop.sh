#!/bin/bash
branch=__default__
ps -ef|grep "$branch"|grep -v grep|awk '{print $2}'|xargs kill -9 >/dev/null 2>&1

ps -ef|grep "redis-server"|grep -v grep|awk '{print $2}'|xargs kill -9 >/dev/null 2>&1
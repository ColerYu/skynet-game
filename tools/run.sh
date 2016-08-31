#!/bin/bash
(./start_redis.sh)

sleep 2
(./start_center.sh)

sleep 2
(./start_gate.sh)

sleep 2
(./start_login.sh)

sleep 2
(./start_lobby.sh)

sleep 2
(./start_dzz.sh)


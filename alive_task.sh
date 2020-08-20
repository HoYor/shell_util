#!/bin/bash

function start_daemon()
{
    echo "开始执行"
    $(pwd)/minion &
    pid=$!
}

function stop_daemon()
{
    kill -TERM $pid
    wait $pid
    ecode=$?
}

function handle_SIGHUP()
{
    stop_daemon
    start_daemon
}

function handle_SIGTERM_SIGINT()
{
    echo "结束执行"
    stop_daemon
    exit $ecode
}

trap handle_SIGHUP SIGHUP
trap handle_SIGTERM_SIGINT SIGTERM SIGINT

ARGS=$@

start_daemon

while :
do
    wait $pid
    if ! kill -0 $pid > /dev/null 2>&1
    then
        start_daemon
    fi
done

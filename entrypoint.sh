#!/bin/bash

# shellcheck disable=SC2086
: ${OS_PROXY_PORT:=8080}

# Set proxy if specified
if [[ -n "${OS_PROXY}" ]] 
then
    gateway="$(ip route | awk '/default via/ {print $3}')"
    [[ "${OS_PROXY}" = "yes" ]] && OS_PROXY="socks5://${gateway}:${OS_PROXY_PORT}"
    [[ "${OS_PROXY}" = "socks5" ]] || [[ "${OS_PROXY}" = "http"* ]] && OS_PROXY="${OS_PROXY}://${gateway}:${OS_PROXY_PORT}"
    export http_proxy="${OS_PROXY}"
    export https_proxy="${OS_PROXY}"
fi

exec /bin/bash

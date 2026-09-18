#!/bin/sh
set -eu

: "${VITE_API_BASE_URL:?VITE_API_BASE_URL must be set}"

case "$VITE_API_BASE_URL" in http://*|https://*) ;; *) exit 1;; esac

case "$VITE_API_BASE_URL" in *\'*|*'"'*) exit 1;; esac

grep -qR '__RUNTIME_API_BASE_URL__' /usr/share/nginx/html \
  || exit 1

find /usr/share/nginx/html -type f \( -name '*.js' -o -name '*.html' \) \
  -exec sed -i "s|__RUNTIME_API_BASE_URL__|${VITE_API_BASE_URL}|g" {} +

exec nginx -g 'daemon off;'

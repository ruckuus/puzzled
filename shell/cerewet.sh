#!/bin/bash

sudo cat /var/log/nginx/web*/*/access.log | awk '{ print $7 }' | sed 's/"//g' | sed 's/,//g' | grep -v "-" | sort -n | uniq -c | sort -n -r | head -n 30

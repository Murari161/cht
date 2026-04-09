#!/bin/bash

export PGPASSWORD='Phenominal2.0'

psql \
  -h 172.27.1.93 \
  -U jmurari \
  -d uganda_dwh \
  -f /home/jmurari/cht_counts/refresh_mvs.sql \
  >> /home/jmurari/cht_counts/logs/mv_refresh.log 2>&1

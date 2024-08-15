#!/bin/sh

bundle exec rails db:prepare
bundle exec puma -C config/puma.rb -e production

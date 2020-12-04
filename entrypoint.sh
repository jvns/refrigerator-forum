#!/usr/bin/env bash

cd /usr/src/app

export PATH=$PATH:$PWD/google-cloud-sdk/bin/

gcloud config set project refrigerator-poetry
echo "================================================================"
gcloud secrets versions access latest --secret="refrigerator-rails-master-key"
gcloud secrets versions access latest --secret="refrigerator-rails-master-key" > config/master.key

# Create the Rails production DB on first run
#RAILS_ENV=production bundle exec rake db:create

# Make sure we are using the most up to date
# database schema
#RAILS_ENV=production bundle exec rake db:migrate

# Do some protective cleanup
#> log/production.log
#rm -f tmp/pids/server.pid

./cloud_sql_proxy -instances=refrigerator-poetry:us-east4:refrigerator-poetry-db=tcp:5432 &

# Run the web service on container startup
# $PORT is provided as an environment variable by Cloud Run
#export DATABASE_URL="postgres://myuser:mypass@localhost/somedatabase"
export DATABASE_URL="postgres://postgres@localhost/postgres"
bundle exec rails server -e production -b 0.0.0.0 -p 8080

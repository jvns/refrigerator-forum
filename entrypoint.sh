#!/usr/bin/env bash
set -eux

cd /usr/src/app

export PATH=$PATH:$PWD/google-cloud-sdk/bin/

gcloud config set project refrigerator-poetry
echo "================================================================"
gcloud --project refrigerator-poetry secrets versions access latest --secret="rails-master-key"
gcloud --project refrigerator-poetry secrets versions access latest --secret="rails-master-key" > config/master.key



# Do some protective cleanup
#> log/production.log
#rm -f tmp/pids/server.pid

./cloud_sql_proxy -instances=refrigerator-poetry:us-east4:refrigerator-db=tcp:5432 &
# Create the Rails production DB on first run
PASSWORD=$(gcloud --project refrigerator-poetry secrets versions access latest --secret="postgres-password")
export DATABASE_URL="postgres://postgres:$PASSWORD@localhost:5432/postgres"
RAILS_ENV=production bundle exec rake db:create
# Make sure we are using the most up to date
# database schema
RAILS_ENV=production bundle exec rake db:migrate

# Run the web service on container startup
# $PORT is provided as an environment variable by Cloud Run
#export DATABASE_URL="postgres://myuser:mypass@localhost/somedatabase"
bundle exec rails server -e production -b 0.0.0.0 -p 8080

FROM ruby:2.6

# Install MySQL client (needed for the connection to Google CloudSQL instance)
RUN apt-get update
RUN apt-get install -y postgresql-client ruby-bundler

# Install production dependencies (Gems installation in
# local vendor directory)
WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
ENV BUNDLE_FROZEN=true
RUN bundle install

# Copy application code to the container image.
# Note: files listed in .gitignore are not copied
# (e.g.secret files)
COPY . .

# Pre-compile Rails assets (master key needed)
RUN RAILS_ENV=production bundle exec rake assets:precompile

# Set Google App Credentials environment variable with Service Account
#ENV GOOGLE_APPLICATION_CREDENTIALS=/usr/src/app/config/photo_album_runner.key

# Setup Rails DB password passed on docker command line (see Cloud Build file)
#ARG DB_PWD
#ENV DATABASE_PASSWORD=${DB_PWD}

# For now we don't have a Nginx/Apache frontend so tell 
# the Puma HTTP server to serve static content
# (e.g. CSS and Javascript files)
ENV RAILS_SERVE_STATIC_FILES=true

# Redirect Rails log to STDOUT for Cloud Run to capture
ENV RAILS_LOG_TO_STDOUT=true

# Designate the initial sript to run on container startup
RUN chmod +x /usr/src/app/entrypoint.sh
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]


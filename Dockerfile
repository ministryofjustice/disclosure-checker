FROM ruby:3.2.3-alpine as builder

# build dependencies:
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    tzdata \
    yarn

WORKDIR /app

COPY Gemfile* .ruby-version ./

RUN gem install bundler -v 2.4.19
RUN bundle config deployment true && \
    bundle config without development test && \
    bundle install --jobs 4 --retry 3

# Install node packages defined in package.json
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile --check-files

# Copy all files to /app
COPY . .

# The following are ENV variables that need to be present by the time
# the assets pipeline run, but doesn't matter their value.
#
ENV EXTERNAL_URL            replace_this_at_build_time
ENV SECRET_KEY_BASE         replace_this_at_build_time
ENV GOVUK_NOTIFY_API_KEY    replace_this_at_build_time

ENV RAILS_ENV production
RUN bundle exec rake assets:precompile

# Copy fonts and images (without digest) along with the digested ones,
# as there are some hardcoded references in the `govuk-frontend` files
# that will not be able to use the rails digest mechanism.
RUN cp -r node_modules/govuk-frontend/dist/govuk/assets/. public/assets/

# tidy up installation
RUN rm -rf node_modules log/* tmp/* /tmp && \
    rm -rf /usr/local/bundle/cache && \
    find /usr/local/bundle/gems -name "*.c" -delete && \
    find /usr/local/bundle/gems -name "*.h" -delete && \
    find /usr/local/bundle/gems -name "*.o" -delete && \
    find /usr/local/bundle/gems -name "*.html" -delete

# Build runtime image
FROM ruby:3.2.3-alpine

# The application runs from /app
WORKDIR /app

# libpq: required to run postgres, tzdata: required to set timezone, nodejs: JS runtime
RUN apk add --no-cache libpq tzdata nodejs

# add non-root user and group with alpine first available uid, 1000
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

# Download RDS certificates bundle -- needed for SSL verification
# We set the path to the bundle in the ENV, and use it in `/config/database.yml`
#
ENV RDS_COMBINED_CA_BUNDLE /usr/src/app/config/rds-combined-ca-bundle.pem
ADD https://s3.amazonaws.com/rds-downloads/rds-combined-ca-bundle.pem $RDS_COMBINED_CA_BUNDLE
RUN chmod +r $RDS_COMBINED_CA_BUNDLE

# Copy files generated in the builder image
COPY --from=builder /app /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

# Create log and tmp
RUN mkdir -p log tmp
RUN chown -R appuser:appgroup db log tmp

ARG APP_BUILD_DATE
ENV APP_BUILD_DATE ${APP_BUILD_DATE}

ARG APP_BUILD_TAG
ENV APP_BUILD_TAG ${APP_BUILD_TAG}

ARG APP_GIT_COMMIT
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}

ENV APPUID 1000
USER $APPUID

ENV PUMA_PORT 3000
EXPOSE $PUMA_PORT

ENTRYPOINT ["./run.sh"]

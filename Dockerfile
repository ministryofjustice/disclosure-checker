FROM ruby:3.3.5-alpine as base

WORKDIR /app

# postgresql-client: to run postgres, tzdata: required to set timezone, nodejs: JS runtime
RUN apk add --no-cache \
    postgresql-client \
    tzdata \
    nodejs

# Ensure latest rubygems is installed
RUN gem update --system

FROM base as builder

# build dependencies:
RUN apk add --no-cache \
    ruby-dev \
    build-base \
    postgresql-dev \
    yarn

COPY Gemfile* .ruby-version package.json yarn.lock ./

RUN bundle config deployment true && \
    bundle config without development test && \
    bundle install --jobs 4 --retry 3 && \
    yarn install --frozen-lockfile

# Copy all files to /app
COPY . .

RUN RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 \
    bundle exec rails assets:precompile

# Copy fonts and images (without digest) along with the digested ones,
# as there are some hardcoded references in the `govuk-frontend` files
# that will not be able to use the rails digest mechanism.
RUN cp -r node_modules/govuk-frontend/dist/govuk/assets/. public/assets/

# Cleanup to save space in the production image
RUN rm -rf node_modules log/* tmp/* /tmp && \
    rm -rf /usr/local/bundle/cache

# Build runtime image
FROM base

# add non-root user and group with alpine first available uid, 1000
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

# Copy files generated in the builder image
COPY --from=builder /app /app
COPY --from=builder /usr/local/bundle/ /usr/local/bundle/

# Create log and tmp
RUN mkdir -p log tmp
RUN chown -R appuser:appgroup ./*

# Set user
USER 1000

ARG APP_BUILD_DATE
ARG APP_BUILD_TAG
ARG APP_GIT_COMMIT
ENV APP_BUILD_DATE ${APP_BUILD_DATE}
ENV APP_BUILD_TAG ${APP_BUILD_TAG}
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}

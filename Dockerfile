FROM ministryofjustice/ruby:2.6.0-webapp-onbuild

# The following ENV variables need to be present by the time the assets precompile run
ENV EXTERNAL_URL needed_for_assets_precompile
ENV RAILS_ENV    production

RUN touch /etc/inittab

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb http://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update && apt-get install yarn nodejs

RUN bundle exec rake assets:precompile

# Copy fonts and images (without digest) along with the digested ones,
# as there are some hardcoded references in the `govuk-frontend` files
# that will not be able to use the rails digest mechanism.
RUN cp node_modules/govuk-frontend/assets/fonts/* public/assets/govuk-frontend/assets/fonts
RUN cp node_modules/govuk-frontend/assets/images/* public/assets/govuk-frontend/assets/images

ARG APP_BUILD_DATE
ENV APP_BUILD_DATE ${APP_BUILD_DATE}

ARG APP_BUILD_TAG
ENV APP_BUILD_TAG ${APP_BUILD_TAG}

ARG APP_GIT_COMMIT
ENV APP_GIT_COMMIT ${APP_GIT_COMMIT}

ENV PUMA_PORT 3000
EXPOSE $PUMA_PORT

ENTRYPOINT ["./run.sh"]

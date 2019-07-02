# Check if you need to disclose your criminal record MVP

[![CircleCI](https://circleci.com/gh/ministryofjustice/disclosure-checker.svg?style=svg)](https://circleci.com/gh/ministryofjustice/disclosure-checker)

This is a Rails application to enable citizens to check when their convictions are spent.
It is based on software patterns developed for the [C100 Application][c100-application].

## Docker

The application can be run inside a docker container. This will take care of the ruby environment, postgres database,
nginx, and any other dependency for you, without having to configure anything in your machine.

* `docker-compose up`

The application will be run in "production" mode, so will be as accurate as possible to a real production environment.
An nginx reverse proxy will also be run to serve the static assets and to fallback to a static error page if the
upstream server (rails with puma) does not respond.

Please note, in production environments this is done in a slightly different way as we don't use docker-compose in those
environments (kubernetes cluster). But the general ideal is the same (nginx reverse proxy).

## Getting Started

* Copy `.env.example` to `.env` and replace with suitable values.

* `bundle install`
* `bundle exec rails db:setup`
* `bundle exec rails db:migrate`
* `bundle exec rails server`

### GOV.UK Frontend (styles, javascript and other assets)

* `brew install yarn` # if you don't have it already
* `yarn` # this will install the dependencies

### For running the tests:

* Copy `.env.test.example` to `.env.test` and replace with suitable values if you expect to run the tests
* `RAILS_ENV=test bundle exec rails db:setup`
* `RAILS_ENV=test bundle exec rails db:migrate`

You can then run all the code linters and tests with:

* `RAILS_ENV=test bundle exec rake`
or
* `RAILS_ENV=test bundle exec rake test:all_the_things`

Or you can run specific tests as follows (refer to *lib/tasks/all_tests.rake* for the complete list):

* `RAILS_ENV=test bundle exec rake spec`
* `RAILS_ENV=test bundle exec rake brakeman`

## Cucumber features

The features can be run manually (these are not part of the default rake task) in any of these forms:

* `bundle exec cucumber features`
* `bundle exec cucumber features/caution.feature`
* `bundle exec cucumber features/conviction.feature`
* `bundle exec cucumber features/conviction_custodial_sentence.feature`
* `bundle exec cucumber features/conviction_discharge.feature`
* `bundle exec cucumber features/conviction_financial.feature`
* `bundle exec cucumber features/conviction_hospital_guardianship_order.feature`
* `bundle exec cucumber features/conviction_youth_rehabilitation_order.feature`
* `bundle exec cucumber features/caution.feature -t @happy_path`

By default cucumber will start a local server on a random port, run features against that server, and kill the server once the features have finished.

If you want to point the features at another server (WARNING: NEVER PRODUCTION!), pass the environment variable CUCUMBER_URL (or set the value in your local `.env` file) when calling cucumber:

* `CUCUMBER_URL=http://server.com bundle exec cucumber features`

## K8s cluster staging environment

There is a staging environment running on [this url][k8s-staging]

The staging env uses http basic auth to restrict access. The username and
password should be available from the MoJ Rattic server, in the Family Justice group.

This environment should be used for any test or demo purposes, user research, etc.
Do not use production for tests as this will have an impact on metrics and will trigger real emails

There is a [deploy repo][deploy-repo] for this staging environment.
It contains the k8s configuration files and also the required ENV variables.

## CircleCI and continuous deployment

CircleCI is used for CI and CD and you can find the configuration in `.circleci/config.yml`

After a successful merge to master, a docker image will be created and pushed to an ECR repository.
It will also trigger an automatic deploy to [staging][k8s-staging].

For more details on the ENV variables needed for CircleCI, refer to the [deploy repo][deploy-repo].

[c100-application]: https://github.com/ministryofjustice/c100-application
[deploy-repo]: https://github.com/ministryofjustice/disclosure-checker-deploy
[k8s-staging]: https://disclosure-checker-staging.apps.live-1.cloud-platform.service.justice.gov.uk

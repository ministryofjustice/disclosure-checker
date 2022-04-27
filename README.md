# Check when to disclose cautions or convictions

[![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=for-the-badge&logo=github&label=MoJ%20Compliant&query=%24.data%5B%3F%28%40.name%20%3D%3D%20%22disclosure-checker%22%29%5D.status&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fgithub_repositories)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/github_repositories#disclosure-checker "Link to report")

[![CI and CD](https://github.com/ministryofjustice/disclosure-checker/actions/workflows/test-build-deploy.yml/badge.svg)](https://github.com/ministryofjustice/disclosure-checker/actions/workflows/test-build-deploy.yml)

This is a Rails application to enable citizens to check when their convictions are spent.
It is based on software patterns developed for the [C100 Application][c100-application].

### Documentation for calculations of convictions

This service follows several rules to calculate spent dates of multiple convictions,
we have documented all of the scenarios known to us in our tests:

- [spec/services/calculators/multiples/given_scenarios_spec.rb](spec/services/calculators/multiples/given_scenarios_spec.rb)
- [spec/services/calculators/multiples/multiple_offenses_calculator_spec.rb](spec/services/calculators/multiples/multiple_offenses_calculator_spec.rb)

We have also added visual graphics to better aid understanding:

- [docs/results](docs/results)

We have also gather together all the documents and information we have gone through in one ticket:

- https://trello.com/c/kT50EDZ7

If for some reason the ticket is not available, please refer to the following:

- https://www.gov.uk/guidance/rehabilitation-periods
- https://hub.unlock.org.uk/knowledgebase/detailedguideroa/
- https://docs.google.com/spreadsheets/d/1ZSCk-wgMfIc22GQahKH_ys4u-E9GWIn6dQ7mm5t1RFI/edit#gid=2019860123

It is important to understand how convictions work, as this is the main reason for the existence of this service.

## Docker

The application can be run inside a docker container. This will take care of the ruby environment, postgres database, 
and any other dependency for you, without having to configure anything in your machine.

* `docker-compose up`

The application will be run in "production" mode, so will be as accurate as possible to a real production environment.

Please note, in production environments this is done in a slightly different way as we don't use docker-compose in those
environments (kubernetes cluster). But the general idea is the same.

## Getting Started

You will need to install [Homebrew](https://brew.sh), to enable the `brew` command.

* Copy `.env.example` to `.env` and replace with suitable values.

* `brew install shared-mime-info`
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

ChromeDriver is needed for the integration tests. It can be installed on Mac using Homebrew: `brew cask install chromedriver`

The features can be run manually (these are not part of the default rake task) in any of these forms:

* `bundle exec cucumber features`
* `bundle exec cucumber features/caution.feature`
* `bundle exec cucumber features/caution.feature -t @happy_path`

Any of the files in the [features](features) directory can be run individually.

By default cucumber will start a local server on a random port, run features against that server, and kill the server once the features have finished.

If you want to show the browser (useful to debug issues) prefix the commands like this:

* `SHOW_BROWSER=1 bundle exec cucumber features/caution.feature`

## K8s cluster staging environment

There is a staging environment running on [this url][k8s-staging]

The staging env uses http basic auth to restrict access. The username and
password should be available from the MoJ Rattic server, in the Family Justice group.

This environment should be used for any test or demo purposes, user research, etc.
Do not use production for tests as this will have an impact on metrics and will trigger real emails

There is a [deploy repo][deploy-repo] for this staging environment.
It contains the k8s configuration files and also the required ENV variables.

## Continuous integration and deployment

GitHub actions are used for CI and CD and you can find the configuration in `.github/workflows/test-build-deploy.yml`

After a successful merge to `main`, a docker image will be created and pushed to an ECR repository.
It will also trigger an automatic deploy to [staging][k8s-staging].

For more details, refer to the [deploy repo][deploy-repo].

[c100-application]: https://github.com/ministryofjustice/c100-application
[deploy-repo]: https://github.com/ministryofjustice/disclosure-checker-deploy
[k8s-staging]: https://disclosure-checker-staging.apps.live.cloud-platform.service.justice.gov.uk

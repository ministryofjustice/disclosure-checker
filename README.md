<div align="center">

<a id="readme-top"></a>

<br>

<img alt="MoJ logo" src="https://moj-logos.s3.eu-west-2.amazonaws.com/moj-uk-logo.png" width="200">

# Disclosure Checker

[![repo standards badge](https://img.shields.io/endpoint?labelColor=231f20&color=005ea5&style=for-the-badge&label=MoJ%20Compliant&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fendpoint%2Fdisclosure-checker&logo=data:image/png;base64,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)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-report/disclosure-checker)

</div>

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

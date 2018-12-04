# Blueberry Rails [![CircleCI](https://circleci.com/gh/blueberryapps/blueberry_rails.svg?style=svg&circle-token=20a1f7352480b65bd50f523291beed7bfc082b07)](https://circleci.com/gh/blueberryapps/blueberry_rails)

A Rails application template used at Blueberry.

[![blueberry](https://www.google.com/a/blueberryapps.com/images/logo.gif)](http://www.blueberry.cz)

## Installation

Install the gem:

    $ gem install blueberry_rails

Then you can run

    $ blueberry_rails newproject

### Available options

Heroku review apps config

    --heroku

Translation Engine

    --translation-engine

Custom Erros

    --custom-errors

Twitter bootstrap

    --bootstrap

Devise

    --devise

Devise model

    --devise_model User

## Gems

Blueberry Rails template contains following gems by default:

* [Better Errors](https://github.com/charliesome/better_errors) for better error pages
* [dotenv](https://github.com/bkeepers/dotenv) for server-side configuration
* [Devise](https://github.com/plataformatec/devise) for user authentication
* [New Relic RPM](https://github.com/newrelic/rpm) for performance monitoring
* [Mailcatcher](http://mailcatcher.me/) for testing & viewing emails
* [PostgreSQL driver (pg)](https://github.com/ged/ruby-pg)
* [slim](http://slim-lang.com/) for templates
* [simple_form](https://github.com/plataformatec/simple_form) for better & easier forms

Testing related:

* [Capybara](https://github.com/jnicklas/capybara) for acceptance testing
* [Guard](https://github.com/ranmocy/guard-rails) for automatically running specs
* [factory_bot](https://github.com/thoughtbot/factory_bot) as a fixtures replacement
* [Rspec](https://github.com/rspec/rspec-rails)

## Other great stuff

* Do not secret token in the repo - load it via ENV variable
* Default Slim application layout
* Generates User model by default (via devise)
* Partial for displaying flash messages in the default layout

## Credits

Based on [suspenders](https://github.com/thoughtbot/suspenders/blob/master/README.md)
gem by [thoughtbot](http://thoughtbot.com/community).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

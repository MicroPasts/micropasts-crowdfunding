# MicroPasts Crowdfunding [![Build Status](https://secure.travis-ci.org/neighborly/neighborly.png?branch=master)](https://travis-ci.org/neighborly/neighborly) [![Coverage Status](https://coveralls.io/repos/neighborly/neighborly/badge.png?branch=master)](https://coveralls.io/r/neighborly/neighborly) [![Code Climate](https://codeclimate.com/github/neighborly/neighborly.png)](https://codeclimate.com/github/neighborly/neighborly) [![Dependency Status](https://gemnasium.com/neighborly/neighborly.png)](https://gemnasium.com/neighborly/neighborly)

## An open source fundraising toolkit for heritage projects

This is the source code repository that runs the [MicroPasts](https://crowdfunded.micropasts.org) Crowdfunding platform, which builds on a fork of [Neighbor.ly](http://neighbor.ly).

# Getting started

### Internationalization

This software was originally created as [Catarse](https://github.com/catarse/catarse), Brazil's first crowdfunding platform.
It was first made in Portuguese then later English support added by [Daniel Walmsley](http://purpose.com). Neighbor.ly focused on making all aspects of the interface in US English. There are still some patches of both languages throughout the software, but overall there is good infrastructure in place to internationalize to the language of your choice.

### Translations

We hope to offer many languages in the future. So if you decide to implement Neighbor.ly in your own language, please let us know so we can include your language here.

### Payment gateways

This platform uses PayPal as the payment gateway.

## How to contribute

Please see the [CONTRIBUTING](CONTRIBUTING.md) file for information on contributing to Neighbor.ly's development.

### Style Guide

Make sure you follow our [style guide](https://github.com/neighborly/guides/).

## Quick Installation

To get everything working, you'll need to have these dependencies installed in your system:

* ImageMagick >= 6.3.5
* Qt ([to compile capybara webkit](https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit))
* PostgreSQL >= 9.3 (with [postgresql-contrib](http://www.postgresql.org/docs/9.3/static/contrib.html))
* Redis >= 2.4
* Ruby 2.1.1

Then, you can run the following commands:

```bash
$ git clone https://github.com/neighborly/neighborly.git
$ cd neighborly
$ ./bin/bootstrap
$ foreman start
```

You are now running Neighborly on http://localhost:3000 with sample configuration. If you plan to use it more than just get it running, you should change configuration (check `db/seeds.rb` for examples) and maybe run development seeds:

```bash
$ rails runner db/development_seeds.rb
```

## Other Repositories

Neighbor.ly consists of many separate services/gems, each with their own source code repository.

### [Neighborly::Api](https://github.com/neighborly/neighborly-api) [![Build Status](https://travis-ci.org/neighborly/neighborly-api.png?branch=master)](https://travis-ci.org/neighborly/neighborly-api) [![Code Climate](https://codeclimate.com/github/neighborly/neighborly-api.png)](https://codeclimate.com/github/neighborly/neighborly-api)

A Rails Engine that contains our API.

### [Neighborly::Admin](https://github.com/neighborly/neighborly-admin) [![Build Status](https://travis-ci.org/neighborly/neighborly-admin.png?branch=master)](https://travis-ci.org/neighborly/neighborly-admin) [![Code Climate](https://codeclimate.com/github/neighborly/neighborly-admin.png)](https://codeclimate.com/github/neighborly/neighborly-admin)

A Rails Engine that deal with all the admin section for Neighbor.ly.

### [Neighborly::Balanced](https://github.com/neighborly/neighborly-balanced) [![Build Status](https://travis-ci.org/neighborly/neighborly-balanced.png?branch=master)](https://travis-ci.org/neighborly/neighborly-balanced) [![Code Climate](https://codeclimate.com/github/neighborly/neighborly-balanced.png)](https://codeclimate.com/github/neighborly/neighborly-balanced)

A Rails Engine that contains the base to integrate Neighbor.ly with Balanced Payments.

### [Neighborly::Balanced::Creditcard](https://github.com/neighborly/neighborly-balanced-creditcard) [![Build Status](https://travis-ci.org/neighborly/neighborly-balanced-creditcard.png?branch=master)](https://travis-ci.org/neighborly/neighborly-balanced-creditcard) [![Code Climate](https://codeclimate.com/github/neighborly/neighborly-balanced-creditcard.png)](https://codeclimate.com/github/neighborly/neighborly-balanced-creditcard)

A Rails Engine that integrate Neighbor.ly to Credit Card on Balanced Payments.

### [Neighborly::Balanced::Bankaccount](https://github.com/neighborly/neighborly-balanced-bankaccount) [![Build Status](https://travis-ci.org/neighborly/neighborly-balanced-bankaccount.png?branch=jl-setup-test-env)](https://travis-ci.org/neighborly/neighborly-balanced-bankaccount) [![Code Climate](https://codeclimate.com/github/neighborly/neighborly-balanced-bankaccount.png)](https://codeclimate.com/github/neighborly/neighborly-balanced-bankaccount)

A Rails Engine that integrate Neighbor.ly to Bank Account (ACH) on Balanced Payments.

## Credits

Originally forked from [Catarse](https://github.com/catarse/catarse).
Adapted by [devton](https://github.com/devton), [josemarluedke](https://github.com/josemarluedke), [irio](https://github.com/irio), and [luminopolis](https://github.com/luminopolis). Made possible by support from hundreds of code contributors, financial support from Knight Foundation and Sunlight Foundation, plus lots of love & bbq sauce in downtown Kansas City, Missouri.

## License

Copyright (c) 2012 - 2014 Neighbor.ly. Licensed as free and open source under the [MIT License](MIT-LICENSE)

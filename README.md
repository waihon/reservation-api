# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

## Terminal Commands

### Project Setup

* `rails new reservation-api --api --skip-test`
* `rvm use 2.7.4@rails6.1 --ruby-version`

### Models

* `bin/rails g model guest`
* `bin/rails g model reservation`
* `bin/rails db:migrate`
* `bin/rails g controller reservations`
* `bin/rails g migration rename_fields_of_guests`
* `bin/rails g migration rename_fields_of_reservations`
* `bin/rails db:migrate`
* `bin/rails g migration rename_phone_of_guests`
* `bin/rails g migration add_localized_description_to_reservations`
* `bin/rails db:migrate`

### Testing

* `bin/rails g rspec:install`
* `mkdir spec/factories`

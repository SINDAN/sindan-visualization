# SINDAN Visualization

## Features
* List of sindan log
* Simple Dashboard

## Requirements
* Ruby 2.6.3 (ref: [.ruby-version](.ruby-version) )
* MySQL

## Getting Started
* Clone from git
    * git clone this repository

* Configure database.yml

    ```
    cp config/database.yml.example config/database.yml
    ```

* Installation

    ```
    bundle install
    bundle exec rails db:migrate
    bundle exec rails db:seed
    ```

* Testing

    ```
    bundle exec rails spec
    ```

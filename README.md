# SINDAN Visualization

## Features
* List of sindan log
* Simple Dashboard

## Requirements
* Ruby 3.4.5 (ref: [.ruby-version](.ruby-version) )
* Node.js 22.17.1 (ref: [.node-version](.node-version) )
* MySQL

## Getting Started
* Clone from git
    * git clone this repository

* Configure database.yml

    ```
    cp config/database.yml.example config/database.yml
    ```

* Installation

    ```sh
    $ bundle install
    $ bundle exec rails db:migrate
    $ bundle exec rails db:seed
    ```

    ```sh
    $ yarn install
    ```

* Development environment

    ```sh
    $ bundle exec bin/dev
    ```

* Testing

    ```sh
    $ bundle exec rails spec
    ```

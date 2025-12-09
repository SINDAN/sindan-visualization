# SINDAN Visualization

## Features
* List of sindan log
* Simple Dashboard

## Requirements
* Ruby 3.4.7 (ref: [.ruby-version](.ruby-version) )
* Node.js 24.11.0 (ref: [.node-version](.node-version) )
* MySQL

## Getting Started
* Clone from git
    * git clone this repository

* Configure database.yml

    ```sh
    cp config/database.yml.example config/database.yml
    ```

* Installation

    ```sh
    bundle install
    bundle exec rails db:migrate
    bundle exec rails db:seed
    ```

    ```sh
    npm install
    ```

* Development environment

    ```sh
    bundle exec bin/dev
    ```

* Testing

    ```sh
    bundle exec rails spec
    ```

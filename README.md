# SINDAN Visualization

## Features
* List of sindan log
* Simple Dashboard

## Requirements
* Ruby 3.1.2 (ref: [.ruby-version](.ruby-version) )
* Node.js 16.16.0 (ref: [.node-version](.node-version) )
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

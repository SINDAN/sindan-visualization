# coding: utf-8
# config valid only for current version of Capistrano
#lock '3.4.0'

set :application, 'sindan_visualization'

set :scm, :git
set :repo_url, 'sh.wide.ad.jp/~sho/sindan'
set :branch, :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :user, 'deploy'
set :deploy_to, '/var/www/sindan-production'

# Set the ruby version
set :rbenv_type, :system
set :rbenv_ruby, '2.2.2'

# server alias
set :sindan, "fluentd.c.u-tokyo.ac.jp"
#set :sindan, "157.82.35.135"
set :sindandev, ""
set :vagrant, '127.0.0.1'

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug # :debug or :info

# Default value for :pty is false
# set :pty, true

set :linked_files, %w{config/database.yml}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :ssh_options, {
  keys: [File.expand_path('~/.ssh/id_rsa')],
  forward_agent: true,
  auth_methods: %w(publickey)
}

set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

namespace :db do

  # linked_filesで使用するファイルをアップロードする
  desc 'upload importabt files'
  task :config do
    on roles(:app) do |host|
      upload!('config/database.yml',"#{shared_path}/config/database.yml")
    end
  end

  desc 'reset databse'
  task :reset do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:migrate:reset"
          execute :rake, "db:seed"
        end
      end
    end
  end

  desc 'add seed data'
  task :seed do
    on roles(:db) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:seed"
        end
      end
    end
  end

  desc 'display a list of pending migrations'
  task :pending_migrations do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "db:abort_if_pending_migrations"
        end
      end
    end
  end
end

namespace :log do

  desc "tail -f accees_log"
  task :tail do
    on roles(:web) do
      env = fetch(:rails_env)
      env = 'develoment' if env == 'staging'
      execute "tail -f #{shared_path}/log/#{env}.log"
    end
  end
end

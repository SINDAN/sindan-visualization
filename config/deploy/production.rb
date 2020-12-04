set :stage, :production

set :branch, "wide-camp2103"
set :deploy_to, "/var/www/sindan-production"
set :rails_env, "production"
set :migration_role, 'db'

server fetch(:sindan), user: fetch(:user), roles: %w{web app db}

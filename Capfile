# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require 'capistrano/rvm'
# require 'capistrano/rbenv'
# require 'capistrano/chruby'
# require 'capistrano/bundler'
# require 'capistrano/rails/assets'
# require 'capistrano/rails/migrations'
# require 'capistrano/passenger'

require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'

require 'capistrano/console'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }


# for git subdirectory
require 'capistrano/recipes/deploy/strategy/remote_cache'

class RemoteCacheSubdir < Capistrano::Deploy::Strategy::RemoteCache
  private
  def repository_cache_subdir
    if configuration[:deploy_subdir] then
      File.join(repository_cache, configuration[:deploy_subdir])
    else
      repository_cache
    end
  end

  def copy_repository_cache
    logger.trace "copying the cached version to #{configuration[:release_path]}"
    if copy_exclude.empty?
      run "cp -RpL #{repository_cache_subdir} #{configuration[:release_path]} && #{mark}"
    else
      exclusions = copy_exclude.map { |e| "--exclude=\"#{e}\"" }.join(' ')
      run "rsync -lrpt #{exclusions} #{repository_cache_subdir}/* #{configuration[:release_path]} && #{mark}"
    end
  end
end

set :strategy, RemoteCacheSubdir.new(self)

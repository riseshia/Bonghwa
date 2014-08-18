load 'deploy'
# Uncomment if you are using Rails' asset pipeline
load 'deploy/assets'

Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| gitload(plugin) }
load 'config/deploy' # remove this line to skip loading any of the default tasks

namespace :db do
  task :db_config, :except => { :no_release => true }, :role => :app do
    run "cp -f /home/shia/webapps/msm.yml #{release_path}/config/database.yml"
  end
end

after "deploy:finalize_update", "db:db_config"
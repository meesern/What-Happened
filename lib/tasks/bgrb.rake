

task :before_restart, :roles => :app do
    restart_backgroundrb
end

task :start_backgroundrb, :roles => :app do
   sudo "nohup /data/#{application}/current/script/backgroundrb start "
end

task :stop_backgroundrb, :roles => :app do
   sudo "kill -9 `cat /data/#{application}/current/log/backgroundrb.pid` 2>/dev/null; true"
end

task :restart_backgroundrb, :roles => :app do
   stop_backgroundrb
   start_backgroundrb
end


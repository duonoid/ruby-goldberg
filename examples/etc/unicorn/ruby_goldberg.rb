worker_processes 1
preload_app true
timeout 60
APP_ROOT = '/opt/ruby-goldberg/app/'
listen File.expand_path('tmp/sockets/unicorn.sock', APP_ROOT)
pid File.expand_path('tmp/pids/unicorn.pid', APP_ROOT)
working_directory APP_ROOT

stderr_path "/var/log/unicorn/ruby_goldberg.stderr.log"
stdout_path "/var/log/unicorn/ruby_goldberg.stdout.log"

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)

before_fork do |server, worker|
  old_pid = File.expand_path('tmp/pids/unicorn.pid.oldbin', APP_ROOT)
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  begin
    uid, gid = Process.euid, Process.egid
    user, group = 'deploy', 'deploy'
    target_uid = Etc.getpwnam(user).uid
    target_gid = Etc.getgrnam(group).gid
    worker.tmp.chown(target_uid, target_gid)
    if uid != target_uid || gid != target_gid
      Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end
  rescue => e
    if RAILS_ENV == 'development'
      STDERR.puts "couldn't change user, oh well"
    else
      raise e
    end
  end
end

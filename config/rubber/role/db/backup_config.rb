<%
  @path = '/root/Backup/backup_conf.rb'
%>
##
# Backup
# Generated Template
#
# For more information:
#
# View the Git repository at https://github.com/meskyanichi/backup
# View the Wiki/Documentation at https://github.com/meskyanichi/backup/wiki
# View the issue log at https://github.com/meskyanichi/backup/issues
#
# When you're finished configuring this configuration file,
# you can run it from the command line by issuing the following command:
#
# $ backup -t my_backup -c <%=@path%> 
# See conf/rubber/rubber-mysql.s3

Backup::Model.new(:database_s3_backup, "Backup gem's S3 backup") do

  database MySQL do |db|
    db.name               = "<%=rubber_env.db_name%>"
    db.username           = "<%=rubber_env.db_user%>"
    db.password           = "<%=rubber_env.db_pass%>"
    db.host               = "localhost"
#    db.port               = 3306
#    db.socket             = "/tmp/mysql.sock"
#    db.skip_tables        = ['skip', 'these', 'tables']
#    db.only_tables        = ['only', 'these' 'tables']
    db.additional_options = ['--quick', '--single-transaction']
  end

  store_with S3 do |s3|
    s3.access_key_id      = 'AKIAITQWVME6VRL6MI7A'
    s3.secret_access_key  = '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'
    s3.region             = 'us-east-1'
    s3.bucket             = 'horizon_trackable_tableware'
#    s3.path               = '/path/to/my/backups'
    s3.keep               = 10
  end

  compress_with Gzip do |compression|
    compression.best = true
    compression.fast = false
  end

  notify_by Mail do |mail|
    mail.on_success           = false
    mail.on_failure           = true

    mail.from                 = 'backup@<%=rubber_env.domain%>'
    mail.to                   = '<%=rubber_env.admin_email%>'
#    mail.address              = 'smtp.gmail.com'
#    mail.port                 = 587
#    mail.domain               = 'your.host.name'
#    mail.user_name            = 'sender@email.com'
#    mail.password             = 'my_password'
#    mail.authentication       = 'plain'
#    mail.enable_starttls_auto = true
  end

end


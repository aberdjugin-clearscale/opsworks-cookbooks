# AWS OpsWorks Recipe for Wordpress to be executed during the Configure lifecycle phase
# - Creates the config file wp-config.php with MySQL data.
# - Creates a Cronjob.
# - Imports a database backup if it exists.

require 'uri'
require 'net/http'
require 'net/https'


#uri = URI.parse("https://api.wordpress.org/secret-key/1.1/salt/")
#http = Net::HTTP.new(uri.host, uri.port)
#http.use_ssl = true
#http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#request = Net::HTTP::Get.new(uri.request_uri)
#response = http.request(request)
#keys = response.body


# Create the Wordpress config file wp-config.php with corresponding values
node[:deploy].each do |app_name, deploy|

    template "#{deploy[:deploy_to]}/current/wp-config.php" do
        source "wp-config.php.erb"
        mode 0660
        group deploy[:group]

        if platform?("ubuntu")
          owner "www-data"
        elsif platform?("amazon")
          owner "apache"
        end

        variables(
            :database   => (node[:opsworks][:database][:database] rescue nil),
            :user       => (node[:opsworks][:database][:username] rescue nil),
            :password   => (node[:opsworks][:database][:password] rescue nil),
            :host       => (node[:opsworks][:database][:host] rescue nil),
	    :auth_key	=> (node[:opsworks][:wpkeys][:AUTH_KEY]),
	    :secure_auth_key	=> (node[:opsworks][:wpkeys][:SECURE_AUTH_KEY]),
	    :logged_in_key	=> (node[:opsworks][:wpkeys][:LOGGED_IN_KEY]),
	    :nonce_key		=> (node[:opsworks][:wpkeys][:NONCE_KEY]),
	    :auth_salt		=> (node[:opsworks][:wpkeys][:AUTH_SALT]),
	    :secure_auth_salt	=> (node[:opsworks][:wpkeys][:SECURE_AUTH_SALT]),
	    :logged_in_salt	=> (node[:opsworks][:wpkeys][:LOGGED_IN_SALT]),
	    :nonce_salt		=> (node[:opsworks][:wpkeys][:NONCE_SALT]),
	    :secret_key		=> (node[:opsworks][:wpkeys][:SECRET_KEY]),
	    :secret_salt	=> (node[:opsworks][:wpkeys][:SECRET_SALT]),
#            :keys       => (keys rescue nil),
	    :cache_srv => node[:opsworks][:deploy][:elasticache]
        )
    end

	
	
	# Import Wordpress database backup from file if it exists
#	mysql_command = "/usr/bin/mysql -h #{deploy[:database][:host]} -u #{deploy[:database][:username]} #{node[:mysql][:server_root_password].blank? ? '' : "-p#{node[:mysql][:server_root_password]}"} #{deploy[:database][:database]}"
#
#	Chef::Log.debug("Importing Wordpress database backup...")
#	script "restore_db" do
#		interpreter "bash"
#		user "root"
#		cwd "#{deploy[:deploy_to]}/current/"
#		code <<-EOH
#			if ls #{deploy[:deploy_to]}/current/*.sql &> /dev/null; then 
#				#{mysql_command} < #{deploy[:deploy_to]}/current/*.sql;
#				rm #{deploy[:deploy_to]}/current/*.sql;
#			fi;
#		EOH
#	end
	
end

# Create a Cronjob for Wordpress
cron "wordpress" do
  hour "*"
  minute "*/15"
  weekday "*"
  command "wget -q -O - http://localhost/wp-cron.php?doing_wp_cron >/dev/null 2>&1"
end

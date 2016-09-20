# AWS OpsWorks Recipe for Wordpress to be executed during the Configure lifecycle phase
# - Configure W3TC master config

template '/srv/www/nimblestorage/current/wp-content/w3tc-config/master.php' do
	source 'master.php.erb'
	owner 'root'
	group 'root'
	mode '0644'
	variables ({
     		:cache_srv => node[:opsworks][:deploy][:elasticache]
    	})
end

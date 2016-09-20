# AWS OpsWorks Recipe for Wordpress to be executed during the Configure lifecycle phase
# - Upload amazon-elasticache-cluster-client.so to PHP.
# - Upload memcached.ini.
# - Create symbolic links.

template '/etc/php5/mods-available/memcached.ini' do
	source 'memcached.ini.erb'
	owner 'root'
	group 'root'
	mode '0644'
	variables ({
     		:cache_srv => node[:deploy][:elasticache]
    	})
end
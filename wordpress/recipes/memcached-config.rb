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
     		:cache_srv => node[:opsworks][:deploy][:elasticache]
    	})
end

link '/etc/php5/apache2/conf.d/20-memcached.ini' do
	to '/etc/php5/mods-available/memcached.ini'
end

link '/etc/php5/cli/conf.d/20-memcached.ini' do
	to '/etc/php5/mods-available/memcached.ini'
end

# AWS OpsWorks Recipe for Wordpress to be executed during the Configure lifecycle phase
# - Upload amazon-elasticache-cluster-client.so to PHP.
# - Upload memcached.ini.
# - Create symbolic links.

cookbook_file '/usr/lib/php5/20121212/amazon-elasticache-cluster-client.so' do
	source 'amazon-elasticache-cluster-client.so'
	owner 'root'
	group 'root'
	mode '0644'
	action :create
end

# template '/etc/php5/mods-available/memcached.ini' do
#	source 'memcached.ini.erb'
#	owner 'root'
#	group 'root'
#	mode '0644'
#	variables ({
#     		:cache_srv => "stg-blue-cache.3cwxgj.cfg.usw2.cache.amazonaws.com:11211"
#    	})
#    	action :nothing
#end

#cookbook_file '/etc/php5/mods-available/memcached.ini' do
#	source 'memcached.ini'
#	owner 'root'
#	group 'root'
#	mode '0644'
#	action :create
#end

#link '/etc/php5/mods-available/memcached.ini' do
#	to '/etc/php5/apache2/conf.d/20-memcached.ini'
#end

#link '/etc/php5/mods-available/memcached.ini' do
#	to '/etc/php5/cli/conf.d/20-memcached.ini'
#end

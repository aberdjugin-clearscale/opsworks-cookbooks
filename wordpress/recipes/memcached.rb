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

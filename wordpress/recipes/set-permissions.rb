## Cookbook Name::
## Recipe:: wordpress
##
## Copyright 2015, ClearScale, Inc.
##
## All rights reserved - Do Not Redistribute
##
#command "chown -R www-data:www-data #{node[:deploy][:nimblestorage][:deploy_to]}/current"

execute 'set_permissions' do
	command "chown -R www-data:www-data /srv/www/nimblestorage"
	action :run
end

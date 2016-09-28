## Cookbook Name::
## Recipe:: wordpress
##
## Copyright 2015, ClearScale, Inc.
##
## All rights reserved - Do Not Redistribute
##
#

execute 'set_permissions' do
	command "chown -R www-data:www-data #{node[:deploy][:nimblestorage][:deploy_to]}/current/wp-content"
	action :run
end

execute 'set_permissions' do
	command "chown -R deploy #{node[:deploy][:nimblestorage][:deploy_to]}/current/wp-content/plugins"
	action :run
end

execute 'set_permissions' do
	command "chown -R deploy #{node[:deploy][:nimblestorage][:deploy_to]}/current/wp-content/themes"
	action :run
end

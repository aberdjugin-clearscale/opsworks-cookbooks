## Cookbook Name::
## Recipe:: wordpress
##
## Copyright 2015, ClearScale, Inc.
##
## All rights reserved - Do Not Redistribute
##
#

execute 'set_permissions' do
	command "chown -R www-data:www-data #{node[:deploy][:nimblestorage][:deploy_to]}/wp-content"
	action :run
end

execute 'set_permissions' do
	command "chown -R root #{node[:deploy][:nimblestorage][:deploy_to]}/wp-content/plugins"
	action :run
end

execute 'set_permissions' do
	command "chown -R root #{node[:deploy][:nimblestorage][:deploy_to]}/wp-content/themes"
	action :run
end

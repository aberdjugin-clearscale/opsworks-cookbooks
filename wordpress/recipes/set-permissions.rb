## Cookbook Name::
## Recipe:: wordpress
##
## Copyright 2015, ClearScale, Inc.
##
## All rights reserved - Do Not Redistribute
##
#

execute 'set_permissions' do
	command "chown -R www-data:www-data #{node[:deploy][:nimblestorage][:deploy_to]}"
	action :run
end

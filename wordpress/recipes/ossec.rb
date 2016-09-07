# AWS OpsWorks Recipe for Wordpress to be executed during the Configure lifecycle phase
# - Install and configure ossec agent

bash 'agent-install' do
  cwd '/root'
  code <<-EOH
apt-key adv --fetch-keys http://ossec.wazuh.com/repos/apt/conf/ossec-key.gpg.key   
echo "deb http://ossec.wazuh.com/repos/apt/ubuntu trusty main" > /etc/apt/sources.list.d/wazuh.list
apt-get update
export DEBIAN_FRONTEND=noninteractive && apt-get install -y ossec-hids-agent
  EOH
not_if "dpkg-query -l ossec-hids-agent 2>/dev/null"
end

template '/var/ossec/etc/ossec.conf' do
  source 'ossec.conf.erb'
  owner 'root'
  group 'root'
  mode 0640
  variables ({
	:OSSEC_SERVER => node[:opsworks][:ossec][:serverip],
	:INSTANCE_TYPE => node[:opsworks][:ossec][:instancetype]
  })
end  
  
# register agent on server
# We need to relaunch agent twice in first time, because at first launch agent just downloads config and share data from server, but doesn't use it.
bash 'register-client' do
  cwd '/root'
  code <<-EOH 
rm -f /var/ossec/etc/client.keys
/var/ossec/bin/agent-auth -m ${node[:opsworks][:ossec][:serverip]} -p 1515 -A `curl http://169.254.169.254/latest/meta-data/instance-id` && echo "true" > /var/ossec/etc/registered
/etc/init.d/ossec stop
sleep 5
/etc/init.d/ossec start
sleep 15
/etc/init.d/ossec stop
sleep 5
/etc/init.d/ossec start
  EOH
not_if { File.exists?("/var/ossec/etc/registered") }
end

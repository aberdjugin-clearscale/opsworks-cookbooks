#!/bin/bash

OSSEC_SERVER_IP="$1"
INSTANCE_TYPE="$2"

if [ ! -f /etc/apt/sources.list.d/wazuh.list ]; then

    apt-key adv --fetch-keys http://ossec.wazuh.com/repos/apt/conf/ossec-key.gpg.key   
    echo "deb http://ossec.wazuh.com/repos/apt/ubuntu trusty main" > /etc/apt/sources.list.d/wazuh.list
    apt-get update
    export DEBIAN_FRONTEND=noninteractive && apt-get install -y ossec-hids-agent
fi

if [ ! -f /var/ossec/etc/registered ]; then

    cat > /var/ossec/etc/ossec.conf <<EOF
<ossec_config>
   <client>
      <server-ip>${OSSEC_SERVER_IP}</server-ip>
      <config-profile>${INSTANCE_TYPE}</config-profile> 
      <notify_time>60</notify_time>
      <time-reconnect>180</time-reconnect>
    </client>
</ossec_config>
EOF

    # remove unnecessary files
    rm -f /var/ossec/etc/client.keys
    rm -f /var/ossec/etc/shared/*
    
    # register agent on server
    /var/ossec/bin/agent-auth -m ${OSSEC_SERVER_IP} -p 1515 -A `curl http://169.254.169.254/latest/meta-data/instance-id` && echo "true" > /var/ossec/etc/registered
  
    # We need to relaunch agent twice in first time, because at first launch agent just downloads config and share data from server, but doesn't use it.
    /etc/init.d/ossec stop
    sleep 5
    /etc/init.d/ossec start
    sleep 15
    /etc/init.d/ossec stop
    sleep 5
    /etc/init.d/ossec start
    sleep 15
fi

/etc/init.d/ossec start

update-rc.d ossec defaults

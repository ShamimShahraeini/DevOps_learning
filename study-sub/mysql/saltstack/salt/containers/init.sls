{% set CONTAINER_NAME = salt['pillar.get'](grains.get('id') + ':container_name') %}

## TODO: 'clean code' rules

include:
  - containers.container-setup
  #- containers.network-setup
  - containers.container-salt-minion

pause_flow:
  salt.runner:
    - name: test.sleep
    - s_time: 5
    - watch:
      - sls: containers.container-salt-minion

# saltmaster_rm_containers_keys:
#   salt.runner:
#     - name: cmd.run
#     - s_name: "rm /etc/salt/pki/master/minions/minion*-{{ CONTAINER_NAME }}"
#     - require:
#         - salt: pause_flow

saltmaster_accept_container_keys:
   salt.wheel:
     - name: key.accept

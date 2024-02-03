
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

saltmaster_accept_container_keys:
   salt.wheel:
     - name: key.accept
     - match: '*'
     - include_rejected: True
     - include_denied: True
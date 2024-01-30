{% set CONTAINER_NAME = 'mysql' %}
{% set BASE_PATH = '/var/lib/machines/' %}

## TODO: ask and search for the reason of: `Failed to get shell PTY: Unit container-shell@1.service was already loaded or has a fragment file + Failed to get shell PTY: Protocol error`
install_saltminion_on_container:
  cmd.run:
    - name: machinectl shell {{ CONTAINER_NAME }} /bin/bash -c 'wget -O - https://bootstrap.saltproject.io | sh'
    - require:
      - sls: containers.container-setup


## TODO: add dynamic "master" config > use grains? maybe
configure_saltminion_on_container:
  file.managed:
    - name: {{ BASE_PATH }}{{ CONTAINER_NAME }}/etc/salt/minion
    - source: salt://containers/configs/minion_config.jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - template: jinja                  
    - CONTAINER_NAME: {{ CONTAINER_NAME }}  
    - MASTER_IP: {{ salt['pillar.get']('master:ip') }}
    - require:
        - cmd: install_saltminion_on_container


key_saltminion_on_container:
  file.absent:
    - name: {{ BASE_PATH }}{{ CONTAINER_NAME }}/etc/salt/pki
    - require:
        - cmd: install_saltminion_on_container

start_salt_minion_on_container:
  cmd.run:
    - name: machinectl shell {{ CONTAINER_NAME }} /bin/bash -c 'systemctl restart salt-minion'
    - require:
      - file: configure_saltminion_on_container


## TODO: add the master state > rm /etc/salt/pki/master/minions/{{ salt['grains.get']('host') }}-{{ CONTAINER_NAME }} && salt-key -A

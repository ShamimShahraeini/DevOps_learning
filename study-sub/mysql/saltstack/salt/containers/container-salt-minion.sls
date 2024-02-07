{% set CONTAINER_NAME = salt['pillar.get'](grains.get('id') + ':container_name') %}
{% set BASE_PATH = salt['pillar.get'](grains.get('id') + ':container_base_path') %}
{% set FULL_PATH = BASE_PATH ~ CONTAINER_NAME %}

############################ salt-minion setup on container

install_saltminion_on_container:
  cmd.run:
    - name: machinectl shell {{ CONTAINER_NAME }} /bin/bash -c 'wget -O - https://bootstrap.saltproject.io | sh'
    - require:
      - sls: containers.container-setup

configure_saltminion_on_container:
  file.managed:
    - name: {{ FULL_PATH }}/etc/salt/minion
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

############################ salt-minion key exchange

start_saltminion_on_container:
  cmd.run:
    - name: machinectl shell {{ CONTAINER_NAME }} /bin/bash -c 'systemctl restart salt-minion'
    - require:
      - file: configure_saltminion_on_container

enable_saltminion_on_container:
  cmd.run:
    - name: machinectl shell {{ CONTAINER_NAME }} /bin/bash -c 'systemctl enable salt-minion'
    - require:
      - file: configure_saltminion_on_container
